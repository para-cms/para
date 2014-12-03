Para::Engine.routes.draw do
  namespace :admin do
    get '/' => 'main#index'

    resources :component_sections, only: [:new, :create, :edit, :update, :destroy] do
      resources :components, only: [:create] do
        collection do
          get ':type/new', action: 'new', as: 'new'
        end
      end
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
