module <%= format_module_name_for(@format) %>
  class <%= model_exporter_name %> < Para::Exporter::Base
    exports '<%= class_name %>'

    def extension
      '<%= @format %>'
    end

    def name
      'export'
    end

    def render
      # Add your export logic here
    end
  end
end
