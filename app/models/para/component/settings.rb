module Para
  module Component
    class Settings < Para::Component::Base
      register :settings, self

      configurable_on :settings, as: :selectize

      def settings
        eval(configuration['settings'])
      end

      def default_form_actions
        [:submit]
      end
    end
  end
end
