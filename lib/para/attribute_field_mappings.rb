require 'para/attribute_field/base'
require 'para/attribute_field/boolean'
require 'para/attribute_field/datetime'
require 'para/attribute_field/password'
require 'para/attribute_field/image'
require 'para/attribute_field/has_many'
require 'para/attribute_field/nested_many'
require 'para/attribute_field/redactor'

module Para
  class AttributeFieldMappings
    UNEDITABLE_ATTRIBUTES = %w(id component_id created_at updated_at type)

    attr_reader :model, :fields_hash, :whitelist_attributes

    def initialize(model, whitelist_attributes: nil)
      @model = model
      @whitelist_attributes = whitelist_attributes

      process_fields!
    end

    def fields
      @fields_hash.values
    end

    private

    def whitelisted?(attribute_name)
      !whitelist_attributes || whitelist_attributes.include?(attribute_name)
    end

    def process_fields!
      @fields_hash = model.columns.each_with_object({}) do |column, fields|
        next unless whitelisted?(column.name)

        # Reject uneditable attributes
        unless UNEDITABLE_ATTRIBUTES.include?(column.name)
          field_class = case column.type
          when :boolean then AttributeField::BooleanField
          when :date, :datetime then AttributeField::DatetimeField
          else AttributeField::Base
          end

          fields[column.name] = field_class.new(
            model, name: column.name, type: column.type
          )
        end
      end.with_indifferent_access

      Para::ModelFieldParsers.parse!(model, fields_hash)
    end
  end
end
