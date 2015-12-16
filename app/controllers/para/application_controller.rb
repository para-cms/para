module Para
  class ApplicationController < ActionController::Base
    include Para::Breadcrumbs::Controller

    add_breadcrumb :home, :admin
  end
end
