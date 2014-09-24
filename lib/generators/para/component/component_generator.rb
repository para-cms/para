module Para
  class ComponentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para component generator'

    def welcome
      say 'Creating component...'
    end

    def copy_component
      template 'component.rb', "app/models/para/component/#{file_name}.rb"
    end

    def copy_component_controller
      template 'component_controller.rb', "app/controllers/admin/#{file_name}_component_controller.rb"
    end

    def add_require_to_application_controller
      prepend_to_file 'app/controllers/application_controller.rb' do
        "require 'para/component/#{file_name}'\n"
      end
    end

    def create_show_component_view
      template 'show.html.haml', "app/views/admin/#{file_name}_component/show.html.haml"
    end

    def add_route
      route_file = File.read(Rails.root.join('config/routes.rb'))

      unless route_file.match /namespace :admin do/
        route "namespace :admin do\n  end\n"
      end

      inject_into_file 'config/routes.rb', after: 'namespace :admin do' do
        "\n    component :#{file_name} do\n    end"
      end
    end
  end
end
