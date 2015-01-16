require 'para/paperclip/has_attached_file_mixin'

module Para
  class Engine < ::Rails::Engine
    isolate_namespace Para

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
      ActiveSupport.on_load :active_record do
        include Para::ActiveRecordOrderableMixin
      end
    end

    initializer 'Extend paperclip attachment definition' do
      if Kernel.const_defined?('Paperclip')
        ::Paperclip::HasAttachedFile.send(
          :include, Para::Paperclip::HasAttachedFileMixin
        )
      end
    end
  end
end
