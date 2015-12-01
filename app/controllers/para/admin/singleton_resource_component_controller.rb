module Para
  module Admin
    class SingletonResourceComponentController < Para::Admin::ComponentController
      attr_accessor :resource
      helper_method :resource

      def show
        self.resource = @component.resource
      end
    end
  end
end
