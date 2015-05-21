module <%= format_module_name_for(@format) %>
  class <%= model_exporter_name %> < Para::Exporter::Csv
    def name
      'export'
    end

    private

    def fields
      [:id]
    end
  end
end
