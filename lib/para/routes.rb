module Para
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location = '/', &block)
      router.instance_eval do
        scope mount_location do
          scope module: :para do
            namespace :admin do
              get '/' => 'main#index'

              crud_component :crud, scope: ':model'
              singleton_resource_component :singleton, scope: ':model'
            end
          end

          block.call if block
        end
      end
    end
  end
end
