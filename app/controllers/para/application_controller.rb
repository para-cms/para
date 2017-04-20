module Para
  class ApplicationController < ActionController::Base
    before_action :add_admin_home_breadcrumb

    def admin?
      true
    end

    private

    def add_admin_home_breadcrumb
      add_breadcrumb :home, admin_path
    end
  end
end
