module Para
  module Exporter
    class Base
      attr_reader :resources
      class_attribute :model_name

      def initialize(resources)
        @resources = resources
      end

      def model
        @model ||= if (model_name = self.class.model_name)
          model_name.constantize
        else
          raise 'You must define model to export in your exporter as following: `exports \'YourModelName\'`'
        end
      end

      def self.exports model_name
        self.model_name = model_name
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
