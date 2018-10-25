module Para
  module Inputs
    class NestedOneInput < NestedBaseInput
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-one"

        parent_model = object.class
        association = object.association(attribute_name)
        relation = parent_model.reflect_on_association(attribute_name)

        resource = object.send(attribute_name)
        model = (resource && resource.class) || relation.klass

        unless resource
          # Build association without trying to save the new record
          resource = case association
          when ActiveRecord::Associations::HasOneThroughAssociation
            association.replace(model.new)
          when ActiveRecord::Associations::HasOneAssociation
            association.replace(model.new, false)
          else
            association.replace(model.new)
          end
        end

        locals = options.fetch(:locals, {})

        template.render(
          partial: 'para/inputs/nested_one',
          locals: {
            form: @builder,
            model: model,
            resource: resource,
            attribute_name: attribute_name,
            nested_locals: locals,
            collapsible: collapsible
          }
        )
      end

      private

      def collapsible
        options.fetch(:collapsible, false)
      end
    end
  end
end
