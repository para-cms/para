module Para
  module MarkupHelper
    def alert(message, options = {}, &block)
      Para::Markup::Alert.new(self).container(message, options, &block)
    end

    def resources_table(options = {}, &block)
      Para::Markup::ResourcesTable.new(self).container(options, &block)
    end

    def panel(options = {}, &block)
      Para::Markup::Panel.new(self).container(options, &block)
    end
  end
end
