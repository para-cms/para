module Para
  module Breadcrumbs
    class Manager
      include Enumerable

      attr_reader :controller

      delegate :length, to: :breadcrumbs

      def initialize(controller)
        @controller = controller
      end

      def add(identifier, path = nil, *args)
        breadcrumbs << Breadcrumb.new(identifier, path, controller, *args)
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
