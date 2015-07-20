module Para
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location = '/', &block)
      routes = self

      router.instance_eval do
        scope mount_location do
          scope module: :para do
            namespace :admin do
              get '/' => 'main#index'

              component :crud do
                scope ':model' do
                  resources :crud_resources, path: '/' do
                    collection do
                      patch :order
                      patch :tree
                      get :export
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

              component :settings do
                resource :settings_form, controller: 'settings_form', only: [:update]
              end
            end
          end

          block.call if block
        end
      end
    end
  end
end
