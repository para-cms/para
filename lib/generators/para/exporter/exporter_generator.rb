module Para
  class ExporterGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :formats, type: :array

    desc 'Para exporter generator'

    def copy_resource_exporter
      formats.each do |format|
        # Set the format to be accessible by the template to define its
        # class name
        @format = format

        template(
          "#{ base_exporter_template_name_for(format) }_exporter.rb",
          "app/exporters/#{ plural_file_name }_exporter.rb"
        )
      end
    end

    private

    def model_exporter_name
      Para::Exporter.model_exporter_name(class_name)
    end

    def base_exporter_template_name_for(format)
      format_specific_template = "../templates/#{ format }_exporter.rb"

      if File.exists?(File.expand_path(format_specific_template, __FILE__))
        format
      else
        'base'
      end
    end
  end
end
