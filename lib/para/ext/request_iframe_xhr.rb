module Para
  module Ext
    module Request
      module IFrameXHR
        # Handle jquery.iframe-transport specific parameter
        def xml_http_request?
          super || iframe_request?
        end
        alias :xhr? :xml_http_request?

        def iframe_request?
          params[:'X-Requested-With'] == 'IFrame'
        end
      end
    end
  end
end
