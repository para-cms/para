module Para
  class ImporterGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para importer generator'

    def copy_resource_importer
      template(
        "base_importer.rb",
        "app/importers/#{ plural_file_name }_importer.rb"
      )
    end

    private

    def model_importer_name
      [class_name.to_s.pluralize, 'Importer'].join
    end
  end
end
