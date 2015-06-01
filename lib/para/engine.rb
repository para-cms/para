module Para
  class Engine < ::Rails::Engine
    initializer 'add vendor path to assets pipeline' do |app|
      %w(javascripts stylesheets).each do |folder|
        app.config.assets.paths << File.expand_path(
          "../../../vendor/assets/#{ folder }",
          __FILE__
        )
      end
    end

    initializer 'Para precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        para/admin.js
        para/admin.css
      )
    end

    initializer 'Para Orderable Mixin' do
      ActiveSupport.on_load(:active_record) do
        include Para::ActiveRecordOrderableMixin
      end
    end

    initializer 'Para Cloneable' do
      ActiveSupport.on_load(:active_record) do
        include Para::Cloneable
      end
    end

    initializer 'Extend paperclip attachment definition' do
      return unless Kernel.const_defined?('Paperclip')

      ActiveSupport.on_load(:active_record) do
        ::Paperclip::HasAttachedFile.send(
          :include, Para::Ext::Paperclip::HasAttachedFileMixin
        )
      end
    end

    initializer 'Extend cancan ControllerResource class' do
      return unless Kernel.const_defined?('CanCan')

      ActiveSupport.on_load(:active_record) do
        ::CanCan::ControllerResource.send(
          :include, Para::Ext::Cancan::ControllerResource
        )
      end
    end

    initializer 'Build components tree' do |app|
      components_config_path = Rails.root.join('config', 'components.rb')

      app.config.to_prepare do
        require components_config_path if File.exist?(components_config_path)
      end
    end
  end
end
