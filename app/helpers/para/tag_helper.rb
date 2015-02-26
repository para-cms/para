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

      render(
        partial: find_partial_for(relation, :list),
        locals: {
          component: @component,
          resources: resources,
          relation: relation,
          model: model,
          attributes: attributes
        }
      )
    end

    def table_for(options)
      partial = :table
      partial = :tree if options[:model].tree?
      render(
        partial: find_partial_for(
          options[:model].name.underscore.pluralize,
          partial
        ),
        locals: options
      )
    end
  end
end
