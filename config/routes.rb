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

    component :crud do
      scope ':model' do
        resources :resources, path: '/'
      end
    end
  end
end
