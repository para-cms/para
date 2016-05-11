module Para
  module Breadcrumbs
    class Breadcrumb
      attr_reader :identifier, :_path, :options

      def initialize(identifier, path, *options)
        @identifier = identifier
        @_path = path
        @options = options
      end

      def title
        @title ||= if Symbol === identifier
          ::I18n.t("admin.breadcrumbs.#{ identifier }")
        else
          identifier
        end
      end

      # Allow lazy evaluation of routes to define breadcrumbs before being
      # able to access request or routes
      def path
        @path ||= if Symbol === _path
          find_route_for(_path, *options)
        elsif _path
          _path
        else
          '#'
        end
      end

      def active?(request)
        path == request.path || !_path
      end

      private

      def find_route_for(path, *options)
        Rails.application.routes.url_helpers.send(:"#{ path }_path", *options)
      end
    end
  end
end
