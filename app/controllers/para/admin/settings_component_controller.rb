module Para
  module Admin
    class SettingsComponentController < Para::Admin::ComponentController
      def show
        @settings = SettingsRails::Form.new
      end
    end
  end
end
