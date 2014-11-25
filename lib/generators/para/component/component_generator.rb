module Para
  class ComponentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para component generator'

    def welcome
      say 'Creating component...'
    end

    def copy_component
      template 'component.rb', "app/components/#{ component_file_name }.rb"
    end

    def copy_component_controller
      template 'component_controller.rb', "app/controllers/admin/#{ component_file_name }_controller.rb"
    end

    def add_require_to_application_controller
      prepend_to_file 'app/controllers/application_controller.rb' do
        "require '#{ component_file_name }'\n"
      end
    end

    def create_show_component_view
      template 'show.html.haml', "app/views/admin/#{ component_file_name }/show.html.haml"
    end

    def add_route
      route_file = File.read(Rails.root.join('config/routes.rb'))

      unless route_file.match /^\s+namespace :admin do/
        route "namespace :admin do\n  end\n"
      end

      inject_into_file 'config/routes.rb', after: '  namespace :admin do' do
        "\n    component :#{ file_name } do\n    end"
      end
    end

    private

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
  end
end
