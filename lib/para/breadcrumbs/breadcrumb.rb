module Para
  module Breadcrumbs
    class Breadcrumb
      include ActionDispatch::Routing::PolymorphicRoutes
      include Para::Helpers::ResourceName

      attr_reader :resource_or_identifier, :_path, :controller, :options

      def initialize(resource_or_identifier, path, controller, *options)
        @resource_or_identifier = resource_or_identifier
        @_path = path
        @controller = controller
        @options = options
      end

      def title
        @title ||= if resource_or_identifier.is_a?(Symbol)
          translate(resource_or_identifier)
        elsif resource_or_identifier.is_a?(ActiveRecord::Base)
          resource_name(resource_or_identifier)
        else
          resource_or_identifier
        end
      end

      # Allow lazy evaluation of routes to define breadcrumbs before being
      # able to access request or routes
      #
      def path
        @path ||= if _path.is_a?(Symbol)
          find_route_for(_path, *options)
        elsif _path
          _path
        else
          begin
            polymorphic_path(resource_or_identifier)
          rescue
            '#'
          end
        end
      end

      def active?(request)
        path == request.path || path == '#'
      end

      private

      def translate(key)
        if controller.admin?
          ::I18n.t("admin.breadcrumbs.#{ resource_or_identifier }")
        else
          # Check if a specific translation has been defined
          if (translation = ::I18n.t("breadcrumbs.#{ resource_or_identifier }", default: '')).present?
            translation
          else
            # If no translation is defined, we check if there's a plural model
            # translation associated to the given key
            begin
              klass = key.to_s.singularize.camelize.constantize
              klass.try(:model_name).try(:human, count: 2) || key
            rescue NameError
              key
            end
          end
        end
      end

      def find_route_for(path, *options)
        path = path_method?(path) ? path.to_sym : :"#{ path }_path"
        Rails.application.routes.url_helpers.send(path, *options)
      end

      # Allow #polymorphic_path to work by delegating missing methods ending
      # with _path or _url to be tried on url_helpers
      #
      def method_missing(method_name, *args, &block)
        if path_method?(method_name)
          Rails.application.routes.url_helpers.try(method_name, *args) || super
        else
          super
        end
      end

      def path_method?(path)
        path.to_s.match(/_(path|url)\z/)
      end
    end
  end
end
