module Para
  module Admin
    class BaseController < ApplicationController
      include Para::Admin::BaseHelper

      if Para.config.authenticate_admin_method
        before_filter Para.config.authenticate_admin_method
      end

      layout 'para/admin'

      def current_admin
        if Para.config.current_admin_method
          send(Para.config.current_admin_method)
        end
      end

      def current_ability
        Ability.new(current_admin)
      end
    end
  end
end
