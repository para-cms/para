module Para
  module MarkupHelper
    def alert(message, options = {}, &block)
      Para::Markup::Alert.new(self).container(message, options, &block)
    end

    def resources_table(component:, **options, &block)
      Para::Markup::ResourcesTable.new(component, self).container(options, &block)
    end

    def panel(options = {}, &block)
      Para::Markup::Panel.new(self).container(options, &block)
    end

    def modal(options = {}, &block)
      Para::Markup::Modal.new(self).container(options, &block)
    end
  end
end
