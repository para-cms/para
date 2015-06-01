module Para
  module Markup
    class ResourcesTable < Para::Markup::Component
      attr_reader :model, :component, :orderable, :actions

      def container(options = {}, &block)
        @model = options.delete(:model)
        @component = options.delete(:component)

        if !options.key?(:orderable) || options.delete(:orderable)
          @orderable = model.orderable?
        end

        if !options.key?(:orderable) || options.delete(:actions)
          @actions = true
        end

        merge_class!(options, 'table')
        merge_class!(options, 'para-component-relation-table')
        merge_class!(options, 'table-hover') if options.fetch(:hover, true)

        if orderable
          merge_class!(options, 'orderable')
          options[:data] ||= {}
          options[:data][:'order-url'] = component.relation_path(model.model_name.route_key, action: :order)
        end

        table = content_tag(:table, options) do
          capture { block.call(self) }
        end

        if options.fetch(:responsive, true)
          content_tag(:div, table, class: 'table-responsive')
        else
          table
        end
      end

      def header(&block)
        cells = []
        # Add orderable empty header
        cells << content_tag(:th, '') if orderable
        # Append cells
        cells << capture { block.call }
        # Append actions empty cell
        cells << content_tag(:th, '', class: 'actions') if actions

        # Output full header
        content_tag(:thead) do
          content_tag(:tr, cells.join("\n").html_safe)
        end
      end

      def rows(resources, &block)
        rows = resources.each_with_object(ActiveSupport::SafeBuffer.new('')) do |resource, buffer|
          buffer << content_tag(:tr, row(resource, &block))
        end

        # Output full header
        content_tag(:tbody, rows)
      end

      def row(resource, &block)
        cells = []
        # Add orderable cell with "move" thumb
        cells << order_cell(resource) if orderable
        # Add data cells
        cells << capture { block.call(resource) }
        # Add actions links to the last cell
        cells << actions_cell(resource) if actions

        cells.join("\n").html_safe
      end

      def header_for(field_name, sort: field_name)
        content_tag(:th) do
          if sort != field_name
              view.sort_link(search, *sort, hide_indicator: true)
          elsif searchable?(field_name)
            view.sort_link(search, field_name, hide_indicator: true)
          else
            model.human_attribute_name(field_name)
          end
        end
      end

      def data_for(*args)
        value = if args.length >= 2
          resource, field_name, type = args
          view.field_value_for(resource, field_name, type).to_s
        else
          view.excerpt_value_for(args.first)
        end

        content_tag(:td) do
          value
        end
      end

      def order_cell(resource)
        order_cell = content_tag(:td) do
          view.reorder_anchor(
            value: resource.position,
            data: { id: resource.id }
          )
        end
      end

      def actions_cell(resource)
        content_tag(:td) do
          content_tag(:div, class: 'pull-right btn-group') do
            edit_button(resource) +
            clone_button(resource) +
            delete_button(resource)
          end
        end
      end

      def clone_button(resource)
        return unless resource.class.cloneable?

        view.link_to(
          component.relation_path(
            resource, action: :clone, return_to: view.request.fullpath
          ),
          method: :post,
          class: 'btn btn-info'
        ) do
          content_tag(:i, '', class: 'fa fa-refresh')
        end
      end

      def edit_button(resource)
        view.link_to(
          component.relation_path(
            resource, action: :edit, return_to: view.request.fullpath
          ),
          class: 'btn btn-primary'
        ) do
          content_tag(:i, '', class: 'fa fa-pencil')
        end
      end

      def delete_button(resource)
        view.link_to(
          component.relation_path(resource),
          method: :delete,
          data: {
            confirm: I18n.t('para.list.delete_confirmation')
          },
          class: 'btn btn-danger'
        ) do
          content_tag(:i, '', class: 'fa fa-trash')
        end
      end

      private

      def search
        @search ||= view.instance_variable_get(:@q)
      end

      def searchable?(field_name)
        model.columns_hash.keys.include?(field_name.to_s)
      end
    end
  end
end
