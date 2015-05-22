module Para
  module Exporter
    class MissingExporterError < StandardError
      attr_accessor :model_name, :format, :exporter_name

      def initialize(model_name, format, exporter_name)
        @model_name = model_name
        @format = format
        @exporter_name = exporter_name
      end

      def message
        "No exporter found for model \"#{ model_name }\" and format " +
        "\"#{ format }\". Please create the #{ exporter_name } class " +
        "manually or with the following command : " +
        "`rails g para:exporter #{ model_name.underscore } #{ format }"
      end
    end

    def self.for(model_name, format)
      exporter_name = name_for(model_name, format)

      begin
        const_get(exporter_name)
      rescue NameError => e
        if e.message == "uninitialized constant Para::Exporter::#{ exporter_name }"
          raise MissingExporterError.new(model_name, format, exporter_name)
        else
          raise e
        end
      end
    end

    def self.name_for(model_name, format)
      [
        '',
        format_exporter_name(format),
        model_exporter_name(model_name)
      ].join('::')
    end

    def self.model_exporter_name(model_name)
      [model_name.to_s.pluralize, 'Exporter'].join
    end

    def self.format_exporter_name(format)
      format.to_s.camelize
    end

    def self.base_exporters
      @base_exporters ||= {}.with_indifferent_access
    end
  end
end

require 'para/exporter/base'
require 'para/exporter/csv'
