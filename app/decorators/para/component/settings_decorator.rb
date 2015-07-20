module Para
  module Component
    module SettingsDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        admin_settings_path(self, options)
      end
    end
  end
end
