module Para
  class AttributeFieldMappings
    UNEDITABLE_ATTRIBUTES = %w(id component_id created_at updated_at type)
    PAPERCLIP_SUFFIXES = %w(file_name content_type file_size updated_at)

    attr_reader :model, :fields_hash

    def initialize(model)
      @model = model

      process_fields!
    end

    def fields
      @fields_hash.values
    end

    def process_fields!
      @fields_hash = model.columns.each_with_object({}) do |column, fields|
        # Reject uneditable attributes
        unless UNEDITABLE_ATTRIBUTES.include?(column.name)
          fields[column.name] = AttributeField.new(
            model, name: column.name, type: column.type
          )
        end
      end.with_indifferent_access

      handle_paperclip_fields!
      handle_relations!
    end

    def handle_paperclip_fields!
      if model.respond_to?(:attachment_definitions)
        model.attachment_definitions.each do |key, _|
          PAPERCLIP_SUFFIXES.each do |suffix|
            field_name = [key, suffix].join('_').to_sym
            @fields_hash.delete(field_name)
          end

          @fields_hash[key] = ImageField.new(
            model, name: key, type: 'file', field_type: 'file'
          )
        end
      end
    end

    def handle_relations!
      model.reflections.each do |name, reflection|
        next if name == :component

        if Publication.nested_attributes_options[name]
          if reflection.collection?
            @fields_hash[name] = NestedManyField.new(
              model, name: name, type: 'has_many', field_type: 'nested_many'
            )
          end
        else

        end
      end
    end
  end

  class AttributeField
    attr_reader :model, :name, :type, :field_type, :field_method

    def initialize(model, options = {})
      @model = model
      @name = options[:name]
      @type = options[:type]
      @field_type = options[:field_type]
      determine_name_and_field_method!
    end

    def determine_name_and_field_method!
      name = @name

      reference = model.reflect_on_all_associations.find do |association|
        association.foreign_key == name
      end

      if reference
        @name = reference.name
        @field_method = :association
      else
        @name = name
        @field_method = :input
      end
    end

    def value_for(instance)
      instance.send(name)
    end
  end

  class ImageField < AttributeField
    include ActionView::Helpers::AssetTagHelper

    def value_for(instance)
      style = attachment_thumb_style_for(instance)
      image_tag(instance.send(name).url(style))
    end

    private

    def attachment_thumb_style_for(instance)
      styles = instance.send(name).styles.map(&:first)
      # Check if there's a :thumb or :thumbnail style in attachment definition
      thumb = styles.find { |s| %w(thumb thumbnail).include?(s.to_s) }
      # Return the potentially smallest size !
      thumb || styles.first || :original
    end
  end

  class HasManyField < AttributeField
    def value_for(instance)
      instance.send(name).map do |resource|
        resource_name(resource)
      end.join(', ')
    end

    private

    def resource_name(resource)
      [:name, :title].each do |method|
        return resource.send(method) if resource.respond_to?(method)
      end

      model_name = resource.class.model_name.human
      "#{ model_name } - #{ resource.id }"
    end
  end

  class NestedManyField < HasManyField
  end
end
