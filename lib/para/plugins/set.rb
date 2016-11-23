module Para
  module Plugins
    class Set
      include Enumerable

      attr_accessor :items

      delegate :+, :<<, :each, to: :items

      def initialize
        @items = []
      end

      def javascript_includes
        each_with_object([]) do |plugin, collection|
          collection.concat(includes_for(:javascript, plugin))
        end
      end

      def stylesheet_includes
        each_with_object([]) do |plugin, collection|
          collection.concat(includes_for(:stylesheet, plugin))
        end
      end

      private

      def includes_for(type, plugin)
        mod = Para::Plugins.module_name_for(plugin).constantize
        mod.try(:config).try(:"#{ type }_includes") || []
      end
    end
  end
end
