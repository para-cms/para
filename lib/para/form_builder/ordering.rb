module Para
  module FormBuilder
    module Ordering
      def orderable?
        options.fetch(:orderable, object.class.orderable?)
      end

      def reorder_anchor(options = {})
        return "" unless orderable?
        options[:form] = self
        template.reorder_anchor(options)
      end
    end
  end
end
