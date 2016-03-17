module Para
  class ComponentGenerator < Rails::Generators::NamedBase
    include Para::Generators::ComponentHelpers

    source_root File.expand_path('../templates', __FILE__)

    desc 'Para component generator'

    def welcome
      say 'Creating component...'
    end

    def copy_component
      template 'component.rb', "app/components/#{ component_file_name }.rb"
    end

    def copy_component_decorator
        template 'decorator.rb', "app/decorators/#{ decorator_file_name }.rb"
      end

    def copy_component_controller
      template 'component_controller.rb', "app/controllers/admin/#{ component_file_name }_controller.rb"
    end

    def create_show_component_view
      template 'show.html.haml', "app/views/admin/#{ component_file_name }/show.html.haml"
    end

    def add_route
      add_component_to_routes :component, file_name
    end

    private

    def component_parent_name
      'Para::Component::Base'
    end
  end
end
