module Para
  module ModelFieldParsers
    class Base
      def self.register(key, parser)
        ModelFieldParsers.registered_parsers[key] = parser
      end

      attr_reader :model, :fields_hash, :mappings

      def initialize(model, fields_hash, mappings)
        @model = model
        @fields_hash = fields_hash
        @mappings = mappings
      end

      def applicable?
        true
      end

      def find_attributes_for_mapping(type)
        mappings.select { |k, v| v == type.to_s }.keys.map(&:to_sym)
      end
    end
  end
end
