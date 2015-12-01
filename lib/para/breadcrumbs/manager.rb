module Para
  module Breadcrumbs
    class Manager
      include Enumerable

      def add(identifier, path = nil, *args)
        breadcrumbs << Breadcrumb.new(identifier, path, *args)
      end

      def breadcrumbs
        @breadcrumbs ||= []
      end

      def each(&block)
        breadcrumbs.each(&block)
      end
    end
  end
end
