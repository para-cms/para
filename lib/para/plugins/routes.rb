module Para
  module Plugins
    class Routes
      attr_reader :router

      def initialize(router)
        @router = router
      end

      def plugin(identifier, &block)
        # Store router reference in closure to allow accessing it from
        # inside the below block
        router = self.router

        router.instance_eval do
          namespace :admin do
            scope module: [:para, identifier].join('/').to_sym, as: identifier do
              router.instance_eval(&block)
            end
          end
        end
      end
    end
  end
end
