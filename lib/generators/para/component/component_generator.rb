module Para
  class ComponentGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :component_name, type: :string

    desc 'Para component generator'

    def welcome
      say 'Creating component...'
      @component_name = component_name.underscore
    end

    def copy_component
      copy_file 'component.rb', "app/models/para/component/#{@component_name}.rb"
    end

    def set_component_name_in_component
      gsub_file "app/models/para/component/#{@component_name}.rb", '%{name}', component_name.camelcase
      gsub_file "app/models/para/component/#{@component_name}.rb", '%{sym}', component_name
    end

    def copy_component_controller
      copy_file 'component_controller.rb', "app/controllers/admin/#{@component_name}_component_controller.rb"
    end

    def set_component_name_in_component_controller
      gsub_file "app/controllers/admin/#{@component_name}_component_controller.rb", '%{name}', component_name.camelcase
      gsub_file "app/controllers/admin/#{@component_name}_component_controller.rb", '%{plural}', component_name.pluralize
    end

    def add_require_to_application_controller
      prepend_to_file 'app/controllers/application_controller.rb' do
        "require 'para/component/#{@component_name}'\n"
      end
    end

    def create_show_component_view
      create_file "app/views/admin/#{@component_name}_component/show.html.haml" do
        "%h1.page-header= @component.name\n"
      end
    end
  end
end
