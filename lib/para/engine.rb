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
      next unless Kernel.const_defined?('Paperclip')

      ActiveSupport.on_load(:active_record) do
        ::Paperclip::HasAttachedFile.send(
          :include, Para::Ext::Paperclip::HasAttachedFileMixin
        )
      end
    end

    initializer 'Extend cancan ControllerResource class' do
      next unless Kernel.const_defined?('CanCan')

      ActiveSupport.on_load(:active_record) do
        ::CanCan::ControllerResource.send(
          :include, Para::Ext::Cancan::ControllerResource
        )
      end
    end

    initializer 'Add resource name methods to simple form extension' do
      ::SimpleFormExtension.name_methods = (
        ::SimpleFormExtension.resource_name_methods +
          Para.resource_name_methods
      ).uniq
    end

    initializer 'Extend active job status\' status class' do
      ActiveSupport.on_load(:active_job) do
        ::ActiveJob::Status::Status.send(
          :include, Para::Ext::ActiveJob::StatusMixin
        )
      end
    end

    initializer 'Build components tree' do |app|
      components_config_path = Rails.root.join('config', 'components.rb')

      app.config.to_prepare do
        require components_config_path if File.exist?(components_config_path)
      end
    end

    initializer 'Check for extensions installation' do
      Para::PostgresExtensionsChecker.check_all
    end

    initializer 'Configure ActiveJob' do
      if ActiveSupport::Cache::NullStore === ActiveJob::Status.store ||
         ActiveSupport::Cache::MemoryStore === ActiveJob::Status.store
      then
        ActiveJob::Status.store = Para.config.jobs_store
      end

      Para::Logging::ActiveJobLogSubscriber.attach_to :active_job
    end

    # Allow generating resources in the gem without having all the unnecessary
    # files generated
    #
    config.generators do |generators|
      generators.skip_routes     true if generators.respond_to?(:skip_routes)
      generators.helper          false
      generators.stylesheets     false
      generators.javascripts     false
      generators.test_framework  false
    end
  end
end
