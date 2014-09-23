module Para
  class Engine < ::Rails::Engine
    isolate_namespace Para

    initializer 'Para precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        para/admin.js
        para/admin.css
      )
    end
  end
end
