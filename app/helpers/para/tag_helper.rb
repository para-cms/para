module Para
  module TagHelper
    def icon_link_to(name, url_options = nil, options = nil, &block)
      if block
        options, url_options = url_options, name
        name = capture { block.call }
      end

      if (icon = options.delete(:icon))
        icon_tag = content_tag(:i, '', class: "fa fa-#{ icon }")
        name = [icon_tag, name].join(' ').html_safe
      end

      link_to(name, url_options, options)
    end

    def listing_for(resources, options = {})
      model = resources.model
      attributes = model_field_mappings(model).fields
      relation = options.fetch(:relation, model.name.to_s.underscore.pluralize)
      allow_adding_resource = options.fetch(:addable, true)

      partial = :list
      partial = :tree if model.respond_to?(:roots) && can?(:tree, model)

      render(
        partial: find_partial_for(relation, partial),
        locals: {
          component: @component,
          resources: resources,
          relation: relation,
          model: model,
          attributes: attributes,
          allow_adding_resource: allow_adding_resource
        }
      )
    end

    def table_for(options)
      partial = :table
      render(
        partial: find_partial_for(
          options[:model].name.underscore.pluralize,
          partial
        ),
        locals: options
      )
    end

    def add_button_for(component, relation, model)
      return unless can?(:create, model)

      partial_name = if component.subclassable?
        :subclassable_add_button
      else
        :add_button
      end

      render partial: find_partial_for(relation, partial_name), locals: {
        component: component, model: model
      }
    end
  end
end
