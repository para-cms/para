module Para
  module Admin
    class BaseController < Para::ApplicationController
      include Para::Admin::BaseHelper

      if Para.config.authenticate_admin_method
        before_filter Para.config.authenticate_admin_method
      end

      before_filter :load_component_sections

      layout 'para/admin'

      def current_admin
        if Para.config.current_admin_method
          send(Para.config.current_admin_method)
        end
      end

      def current_ability
        Ability.new(current_admin)
      end

      private

      def load_component_sections
        @component_sections = Para::ComponentSection.ordered.includes(:components)
      end

      def self.load_and_authorize_component(options = {})
        before_filter do
          load_and_authorize_component(options)
        end
      end

      def load_and_authorize_component(options = {})
        options.reverse_merge!(class:  'Para::Component::Base', find_by: :slug)

        loader = self.class.cancan_resource_class.new(self, :component, options)
        loader.load_and_authorize_resource

        ActiveDecorator::Decorator.instance.decorate(@component) if @component
      end
    end
  end
end
