require 'para/attribute_field/base'
require 'para/attribute_field/boolean'
require 'para/attribute_field/image'
require 'para/attribute_field/has_many'
require 'para/attribute_field/nested_many'

module Para
  class AttributeFieldMappings
    UNEDITABLE_ATTRIBUTES = %w(id component_id created_at updated_at type)
    PAPERCLIP_SUFFIXES = %w(file_name content_type file_size updated_at)

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
          else AttributeField::Base
          end

          fields[column.name] = field_class.new(
            model, name: column.name, type: column.type
          )
        end
      end.with_indifferent_access

      handle_paperclip_fields!
      handle_relations!
      handle_oderable!
    end

    def handle_paperclip_fields!
      if model.respond_to?(:attachment_definitions)
        model.attachment_definitions.each do |key, _|
          PAPERCLIP_SUFFIXES.each do |suffix|
            field_name = [key, suffix].join('_').to_sym
            @fields_hash.delete(field_name)
          end

          @fields_hash[key] = AttributeField::ImageField.new(
            model, name: key, type: 'image', field_type: 'image'
          )
        end
      end
    end

    def handle_oderable!
      if model.orderable?
        fields_hash.delete(:position)
      end
    end

    def handle_relations!
      model.reflections.each do |name, reflection|
        next if name == :component

        if Publication.nested_attributes_options[name]
          if reflection.collection?
            @fields_hash[name] = AttributeField::NestedManyField.new(
              model, name: name, type: 'has_many', field_type: 'nested_many'
            )
          end
        end
      end
    end
  end
end
