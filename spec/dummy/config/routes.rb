Rails.application.routes.draw do
  para_at '/'
  devise_for :admin_users

  root to: 'home#index'
end
