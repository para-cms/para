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
      create_file "app/views/admin/#{file_name}_component/show.html.haml" do
        "%h1.page-header= @component.name\n"
      end
    end

    def add_route
      inject_into_file 'config/routes.rb', after: 'namespace :admin do' do
        "\n    component :#{file_name}"
      end
    end
  end
end
