module Para
  class ApplicationController < ActionController::Base
    add_flash_types :error

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end
  end
end
