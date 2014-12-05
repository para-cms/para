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
        resources :crud_resources, path: '/' do
          collection do
            patch 'order'
          end
        end
      end
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
