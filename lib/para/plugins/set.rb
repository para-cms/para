module Para
  module Plugins
    class Set
      include Enumerable

      attr_accessor :items

      delegate :<<, :each, to: :items

      def initialize
        @items = []
      end

      def javascript_includes
        each_with_object([]) do |plugin, collection|
          collection.concat(javascript_includes_for(plugin))
        end
      end

      private

      def javascript_includes_for(plugin)
        mod = Para::Plugins.module_name_for(plugin).constantize

        mod.try(:config).try(:javascript_includes) || []
      end
    end
  end
end
