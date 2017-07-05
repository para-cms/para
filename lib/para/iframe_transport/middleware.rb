module Para
  module IframeTransport
    class Middleware
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response_body = app.call(env)

        # Build a rails request to allow using its API to analyze the request
        # format and mode
        request = ActionDispatch::Request.new(
          Rails.application.env_config.merge(env)
        )

        # If the request is an Ajax IFrame tranport one, we add a hidden field
        # to the response body to pass response informations that can't be
        # retrieved with headers to the javascript client.
        if matching_request?(request)
          add_status_to_response(request, response_body)
        end

        [status, headers, response_body]
      end

      private

      def matching_request?(request)
        request.iframe_request? && request.format.html?
      end

      def add_status_to_response(request, response_body)
        response = response_body.instance_variable_get(:@response)

        html = Nokogiri::HTML::DocumentFragment.parse(response.body)

        input = Nokogiri::XML::Node.new("input", html).tap do |node|
          node[:type] = 'hidden'
          node[:'data-iframe-response-data'] = true
          node[:'data-type'] = request.format
          node[:'data-status'] = response.status
          node[:'data-statusText'] = response.status_message
        end

        if (body = html.at('body'))
          input.parent = body
        else
          html << input
        end

        response.body = html.to_html
      end
    end
  end
end
