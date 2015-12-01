module Para
  class ApplicationController < ActionController::Base
    include Para::Breadcrumbs::Controller

    add_breadcrumb :home, :admin

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end
  end
end
