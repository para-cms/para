Para::Engine.routes.draw do
  namespace :admin do
    get '/' => 'main#index'

    component :crud do
      scope ':model' do
        resources :crud_resources, path: '/' do
          collection do
            patch :order
            patch :tree
          end

          member do
            post :clone
          end
        end
      end
    end

    component :singleton_resource, path: 'resource-form' do
      resource :singleton_resource, path: 'resource', only: [:create, :update]
    end
  end
end
