module Para
  module Generators
    module FieldHelpers
      private

      def attributes
        @attributes ||= begin
          model = Para.const_get(class_name)
          AttributeFieldMappings.new(model).fields
        end
      end

      def field_options_for(field)
        field_options = field.field_options

        options = field_options.each_with_object([]) do |(key, value), ary|
          if writable_value?(value)
            ary << "#{ key.inspect } => #{ value.inspect }"
          end
        end

        ", #{ options.join(', ') }" if options.any?
      end

      def writable_value?(value)
        [String, Symbol].any? do |type|
          value.kind_of?(type)
        end
      end
    end
  end
end
