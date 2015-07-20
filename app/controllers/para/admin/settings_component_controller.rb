module Para
  module Admin
    class SettingsComponentController < Para::Admin::BaseController
      load_and_authorize_component

      def show
        @settings = SettingsRails::Form.new
      end
    end
  end
end
