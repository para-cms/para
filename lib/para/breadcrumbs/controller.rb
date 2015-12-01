module Para
  module Breadcrumbs
    module Controller
      extend ActiveSupport::Concern

      included do
        class_attribute :_class_level_breadcrumbs

        helper_method :add_breadcrumb, :breadcrumbs
        helper ViewHelper
      end

      def add_breadcrumb(*args)
        breadcrumbs.add(*args)
      end

      def breadcrumbs
        Para.store[:breadcrumbs] ||= begin
          manager = Breadcrumbs::Manager.new
          _class_level_breadcrumbs.each { |args| manager.add(*args) }
          manager
        end
      end

      module ClassMethods
        def add_breadcrumb(*args)
          self._class_level_breadcrumbs ||= []
          self._class_level_breadcrumbs += [args]
        end
      end

      module ViewHelper
        def render_breadcrumbs
          render partial: 'para/admin/shared/breadcrumbs'
        end
      end
    end
  end
end
