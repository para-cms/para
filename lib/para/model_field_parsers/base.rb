module Para
  module ModelFieldParsers
    class Base
      def self.register(key, parser)
        ModelFieldParsers.registered_parsers[key] = parser
      end

      attr_reader :model, :fields_hash

      def initialize(model, fields_hash)
        @model = model
        @fields_hash = fields_hash
      end

      def applicable?
        true
      end
    end
  end
end
