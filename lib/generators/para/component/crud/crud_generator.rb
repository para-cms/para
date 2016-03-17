module Para
  module Component
    class CrudGenerator < Rails::Generators::NamedBase
      include Para::Generators::ComponentHelpers

      source_root File.expand_path('../../templates', __FILE__)

      desc 'Para CRUD component generator'

      def welcome
        say 'Creating CRUD component...'
      end

      def copy_crud_component
        template 'component.rb', "app/components/#{ component_file_name }.rb"
      end

      def copy_crud_component_decorator
        template 'decorator.rb', "app/decorators/#{ decorator_file_name }.rb"
      end

      def copy_crud_resources_controller
        template 'resources_controller.rb', "app/controllers/admin/#{ resources_controller_name }.rb"
      end

      def add_route
        add_component_to_routes :crud_component, file_name
      end

      private

      def component_parent_name
        'Para::Component::Crud'
      end

      def controller_parent_name
        'Para::Admin::CrudResourcesController'
      end
    end
  end
end
