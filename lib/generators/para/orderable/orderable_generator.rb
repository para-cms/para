module Para
  class OrderableGenerator < Para::Generators::NamedBase
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    class_option :migrate, type: :boolean, default: false, :aliases => "-m"

    desc 'Para orderable model updater'

    def welcome
      say "Making #{ class_name } model orderable ..."
    end

    def add_field_to_model
      migration_template(
        'orderable_migration.rb',
        "db/migrate/add_orderable_position_to_#{ table_name }.rb"
      )
    end

    def add_orderable_to_model
      class_definition = "class #{ class_name } < ActiveRecord::Base\n"

      inject_into_file "app/models/#{ singular_namespaced_path }.rb", after: class_definition do
        "  acts_as_orderable\n"
      end
    end

    def migrate
      rake 'db:migrate' if options[:migrate]
    end

    def fianl_message
      message = "The #{ class_name } model is now orderable.\n"
      message << "Please migrate to update your model's table\n" unless options[:migrate]

      say(message)
    end

    def self.next_migration_number(dir)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end
  end
end
