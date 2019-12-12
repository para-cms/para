module Para
  module Markup
    class ResourcesTable < Para::Markup::Component
      class_attribute :default_actions
      self.default_actions = [:edit, :clone, :delete]

      attr_reader :component, :model, :orderable, :actions

      def initialize(component, view, options={})
        @component = component
        @actions = options[:actions] ||= actions
        super(view)
      end

      def container(options = {}, &block)
        @model = options.delete(:model)

        if !options.key?(:orderable) || options.delete(:orderable)
          @orderable = model.orderable?
        end

        @actions = build_actions(options.delete(:actions))

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
        cells << content_tag(:th, '', class: 'table-row-actions') if @actions

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
        cells << actions_cell(resource) if @actions

        cells.join("\n").html_safe
      end

      def header_for(field_name = nil, options = {}, &block)
        if Hash === field_name
          options = field_name
          field_name = nil
        end

        label = if Symbol === field_name
          model.human_attribute_name(field_name)
        elsif block
          capture { block.call }
        else
          field_name
        end

        content_tag(:th, options) do
          if (sort = options.delete(:sort))
            view.sort_link(search, *sort, label, hide_indicator: true)
          elsif searchable?(field_name)
            view.sort_link(search, field_name, label, hide_indicator: true)
          else
            label
          end
        end
      end

      # Data for can accept 2 versions of arguments :
      #
      #   - resource, field_name, type : cell value will be retrieved from
      #       the field_value_for helper
      #
      #   - a single value : The value to display in the cell directly
      #       which will be processed to be shorter than 100 chars
      #
      def data_for(*args, &block)
        value = if args.length >= 2
          resource, field_name, type = args
          view.field_value_for(resource, field_name, type).to_s
        elsif block
          capture { block.call }
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
        buttons = ResourcesButtons.new(component, view)

        content_tag(:td, class: 'table-row-actions') do
          actions.map do |type|
            buttons.send(:"#{ type }_button", resource)
          end.compact.join.html_safe
        end
      end

      private

      def search
        @search ||= view.instance_variable_get(:@q)
      end

      def searchable?(field_name)
        model.columns_hash.keys.include?(field_name.to_s)
      end

      def build_actions(actions)
        if actions.in?([true, nil])
          default_actions
        else
          actions
        end
      end
    end
  end
end
