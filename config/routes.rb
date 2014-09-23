Para::Engine.routes.draw do
  namespace :admin do
    get '/' => 'main#index'

    resources :components, only: [:create]

    component :page do
      resource :page, controller: 'page'
    end

    component :page_category, path: 'category' do
      resources :pages
    end
  end
end
