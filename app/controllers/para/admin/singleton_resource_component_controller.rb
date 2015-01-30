module Para
  module Admin
    class SingletonResourceComponentController < Para::Admin::BaseController
      load_and_authorize_component

      attr_accessor :resource
      helper_method :resource

      def show
        self.resource = @component.resource
      end
    end
  end
end
