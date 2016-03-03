module Para
  module Inputs
    class NestedOneInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-one"

        parent_model = object.class
        association = object.association(attribute_name)
        relation = parent_model.reflect_on_association(attribute_name)
        model = relation.klass

        unless (resource = object.send(:"#{ attribute_name }"))
          # Build association without trying to save the new record
          resource = case association
          when ActiveRecord::Associations::HasOneAssociation
            association.replace(model.new, false)
          else
            association.replace(model.new)
          end
        end

        template.render(
          partial: 'para/inputs/nested_one',
          locals: {
            form: @builder,
            model: model,
            resource: resource,
            attribute_name: attribute_name
          }
        )
      end
    end
  end
end
