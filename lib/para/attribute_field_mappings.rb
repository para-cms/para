require 'para/attribute_field/base'
require 'para/attribute_field/boolean'
require 'para/attribute_field/datetime'
require 'para/attribute_field/password'
require 'para/attribute_field/file'
require 'para/attribute_field/image'
require 'para/attribute_field/relation'
require 'para/attribute_field/belongs_to'
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
      fields_hash.values
    end

    def field_for(field_name, type = nil)
      fields_hash[field_name] ||= if model.new.respond_to?(field_name)
        build_field_for(field_name, type)
      else
        raise NoMethodError.new(
          "No attribute or method correspond to ##{ field_name } " +
          "in the model #{ model.name }. No field could be created."
        )
      end
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
          field_class = field_class_for(column.type)

          fields[column.name] = field_class.new(
            model, name: column.name, type: column.type
          )
        end
      end.with_indifferent_access

      Para::ModelFieldParsers.parse!(model, fields_hash)
    end

    def build_field_for(attribute_name, type)
      field_class = field_class_for(type)

      field_class.new(
        model, name: attribute_name, type: type
      )
    end

    def field_class_for(type)
      case type
      when :boolean then AttributeField::BooleanField
      when :date, :datetime then AttributeField::DatetimeField
      else AttributeField::Base
      end
    end
  end
end
