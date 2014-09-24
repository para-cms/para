module Para
  class ResourceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :component_name, type: :string
    argument :attributes, type: :array

    desc 'Para resource generator'

    def welcome
      say 'Creating resource...'
    end

    def copy_resource_controller
      template 'resource_controller.rb', "app/controllers/admin/#{plural_file_name}_controller.rb"
    end

    def insert_route
      inject_into_file 'config/routes.rb', after: "component :#{component_name.underscore} do" do
        "\n      resources :#{plural_file_name}"
      end
    end

    def generate_model
      generate 'model', file_name
    end

    def insert_belongs_to_to_model
      inject_into_file "app/models/#{file_name}.rb", after: "class #{component_name.camelize} < ActiveRecord::Base" do
        "\n  belongs_to :component, class_name: 'Para::Component::Base'"
      end
    end
  end
end