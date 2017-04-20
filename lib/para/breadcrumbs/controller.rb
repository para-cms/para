module Para
  module Breadcrumbs
    module Controller
      extend ActiveSupport::Concern

      included do
        class_attribute :_class_level_breadcrumbs

        before_action :build_breadcrumbs_manager

        helper_method :add_breadcrumb, :breadcrumbs
        helper ViewHelper
      end

      def add_breadcrumb(*args)
        breadcrumbs.add(*args)
      end

      def breadcrumbs
        build_breadcrumbs_manager
      end

      private

      def build_breadcrumbs_manager
        Para.store['para.breadcrumbs'] ||=
          Breadcrumbs::Manager.new(self).tap do |manager|
            if _class_level_breadcrumbs
              _class_level_breadcrumbs.each { |args| manager.add(*args) }
            end
          end
      end

      module ClassMethods
        def add_breadcrumb(*args)
          self._class_level_breadcrumbs ||= []
          self._class_level_breadcrumbs += [args]
        end
      end

      module ViewHelper
        # Render the breadcrumbs view depending wether it is in the admin or
        # in front, allowing the front view to be overriden in app
        #
        def render_breadcrumbs
          prefix = controller.admin? ? 'para/admin/' : ''
          render partial: "#{ prefix }shared/breadcrumbs"
        end
      end
    end
  end
end
