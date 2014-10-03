module Para
  class Engine < ::Rails::Engine
    isolate_namespace Para

    initializer 'Para precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        para/admin.js
        para/admin.css
      )
    end

    initializer 'Para Orderable Mixin' do
      ActiveSupport.on_load :active_record do
        include Para::ActiveRecordOrderableMixin
      end
    end
  end
end
