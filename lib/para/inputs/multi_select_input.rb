module Para
  module Inputs
    class MultiSelectInput < SimpleForm::Inputs::Base
      include Para::Helpers::ResourceName
      include Para::ModelHelper
      include Para::SearchHelper

      attr_reader :resource

      def input(wrapper_options = nil)
        input_html_options[:class] << "multi-select"

        # Load existing resources
        resources = input_html_options[:value] || object.send(attribute_name)
        # Order them if the list should be orderable
        resources = resources.sort_by(&method(:resource_position)) if orderable?

        template.render(
          partial: 'para/inputs/multi_select',
          locals: {
            form: @builder,
            model: model,
            attribute_name: foreign_key,
            orderable: orderable?,
            resources: resources,
            option_resources: option_resources,
            search_param: search_param,
            collection: collection
          }
        )
      end

      def option_resources
        @option_resources ||= if model.orderable?
          collection.ordered
        else
          collection.sort_by { |resource| resource_name(resource) }
        end
      end

      def parent_model
        @parent_model ||= @builder.object.class
      end

      def model
        @model ||= reflection.klass
      end

      def reflection
        @reflection ||= parent_model.reflect_on_association(attribute_name)
      end

      def foreign_key
        :"#{ reflection.name.to_s.singularize }_ids"
      end

      def attribute_field
        @attribute_field ||= AttributeField::HasManyField.new(
          object.class, name: attribute_name
        )
      end

      def search_param
        @search_param ||= options.fetch(:search_param) do
          attributes = model_field_mappings(model).fields
          fulltext_search_param_for(attributes)
        end
      end

      def collection
        @collection ||= options.fetch(:collection) do
          model.all
        end
      end

      def orderable?
        @orderable ||= options.fetch(:orderable) do
          if attribute_field.through_reflection
            attribute_field.through_reflection.klass.orderable?
          else
            model.orderable?
          end
        end
      end

      def resource_position(resource)
        existing_resource = if attribute_field.through_reflection
          join_resources.find do |res|
            res.send(attribute_field.through_relation_source_foreign_key) == resource.id
          end
        end

        existing_resource.position
      end

      def orderable_association
        @orderable_association ||= if attribute_field.through_reflection
          object.association(attribute_field.through_reflection.name)
        else
          object.association(attribute_name)
        end
      end

      def join_resources
        @join_resources ||= orderable_association.load_target
      end
    end
  end
end
