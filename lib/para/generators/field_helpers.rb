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

      def field_options_for(field, options = {})
        field_options = field.field_options.merge(options)

        options = field_options.each_with_object([]) do |(key, value), ary|
          if writable_value?(value)
            if key.to_s.match(/^[\w\d]+/)
              join_symbol = ': '
            else
              join_symbol = ' => '
              key = key.inspect
            end

            ary << [key, join_symbol, value.inspect].join
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
