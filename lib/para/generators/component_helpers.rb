module Para
  module Generators
    module ComponentHelpers
      private

      def add_component_to_routes(component_type, name)
        route_file = File.read(Rails.root.join('config/routes.rb'))

        unless route_file.match /^\s+namespace :admin do/
          route "namespace :admin do\n  end\n"
        end

        inject_into_file 'config/routes.rb', after: '  namespace :admin do' do
          "\n    #{ component_type } :#{ name }"
        end
      end

      def component_name
        if class_name.match(/Component/i)
          class_name
        else
          "#{ class_name }Component"
        end
      end

      def component_file_name
        if file_name.match(/component/i)
          file_name
        else
          "#{ file_name }_component"
        end
      end

      def decorator_parent_name
        @decorator_parent_name ||= [component_parent_name, 'Decorator'].join
      end

      def resources_controller_name
        @resources_name ||= [
          singular_name.singularize, 'resources', 'controller'
        ].join('_')
      end

      def controller_name
        @controller_name ||= resources_controller_name.camelize
      end

      def decorator_file_name
        @decorator_file_name ||= [component_file_name, 'decorator'].join('_')
      end

      def decorator_name
        @decorator_name ||= decorator_file_name.camelize
      end
    end
  end
end
