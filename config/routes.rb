Para::Engine.routes.draw do
  namespace :admin do
    get '/' => 'main#index'

    resources :component_sections, only: [:new, :create, :edit, :update, :destroy] do
      resources :components, only: [:new, :create]
    end

    component :page do
      resource :page, controller: 'page'
    end

    component :page_category, path: 'category' do
      resources :pages
    end

    #Theme routes
    get 'iframe_left_column' => 'theme#iframe_left_column'
    get 'iframe_right_column' => 'theme#iframe_right_column'
    get 'gallery' => 'theme#gallery'
    get 'calendar' => 'theme#calendar'
    get 'faq' => 'theme#faq'
    get 'ui_kits' => 'theme#ui_kits'
  end
end
