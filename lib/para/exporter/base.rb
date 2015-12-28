module Para
  module Exporter
    class Base
      attr_reader :resources, :model

      def initialize(resources)
        @resources = resources
        @model = @resources.model
      end

      def disposition
        'inline'
      end

      def extension
        raise '#extension must be defined to create the export file name'
      end

      def file_name
        @file_name ||= [name, extension].join('.')
      end

      def self.register_base_exporter(type, exporter)
        Exporter.base_exporters[type] = exporter
      end
    end
  end
end
