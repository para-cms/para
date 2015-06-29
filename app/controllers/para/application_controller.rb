module Para
  class ApplicationController < ActionController::Base
    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end
  end
end
