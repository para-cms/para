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
        ::Paperclip::HasAttachedFile.prepend Para::Ext::Paperclip::HasAttachedFileMixin
      end
    end

    initializer 'Extend ActionDispatch::Request with xhr? method IFrame transport support' do
      ActiveSupport.on_load(:action_controller) do
        ActionDispatch::Request.prepend Para::Ext::Request::IFrameXHR
      end
    end

    initializer 'Add resource name methods to simple form extension' do
      ::SimpleFormExtension.resource_name_methods = (
        Para.config.resource_name_methods +
          ::SimpleFormExtension.resource_name_methods
      ).uniq
    end

    initializer 'Extend active job status\' status class' do
      ActiveSupport.on_load(:active_job) do
        ::ActiveJob::Status::Status.send(
          :include, Para::Ext::ActiveJob::StatusMixin
        )
      end
    end

    initializer 'Override ActiveRecord::NestedAttributes' do
      ActiveSupport.on_load(:active_record) do
        prepend Para::Ext::ActiveRecord::NestedAttributes
        extend Para::Ext::ActiveRecord::NestedAttributesClassMethods
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

    initializer 'Initialize simple form wrappers' do
      Para::SimpleFormConfig.configure
    end

    initializer 'Configure ActiveJob' do
      if ActiveSupport::Cache::NullStore === ActiveJob::Status.store ||
         ActiveSupport::Cache::MemoryStore === ActiveJob::Status.store
      then
        ActiveJob::Status.store = Para.config.jobs_store
      end

      Para::Logging::ActiveJobLogSubscriber.attach_to :active_job
    end

    # Allow any view or helper to check wether it is rendered inside the
    # para admin by defaulting to false, and being overriden in
    # Para::ApplicationController with true
    #
    initializer 'Add #admin? method to ActionController::Base' do
      ActiveSupport.on_load(:action_controller) do
        define_method(:admin?) { false }
      end
    end

    initializer 'Include breadcrumbs manager in app ApplicationController' do
      ActiveSupport.on_load(:action_controller) do
        if Para.config.enable_app_breadcrumbs
          include Para::Breadcrumbs::Controller
        else
          Para::ApplicationController.send(:include, Para::Breadcrumbs::Controller)
        end
      end
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
