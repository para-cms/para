module Para
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para install generator'

    def welcome
      say 'Installing para engine ...'
    end

    def copy_initializer_file
      copy_file 'initializer.rb', 'config/initializers/para.rb'
    end

    def copy_components_config
      copy_file 'components.rb', 'config/components.rb'
    end

    def copy_migrations
      rake 'para_engine:install:migrations'
    end

    def install_gems
      gemfile_contents = File.read(Rails.root.join('Gemfile'))

      [
        ['devise', '>= 3.0'],
        # Allows for installing default wrappers and bootstrap adapters
        # This should be avoided when add an initializer namespaced to the
        # para environment
        ['simple_form'],
        ['simple_form_extension'],
        # Pull requests are pending, and I don't want to release the gem
        # under another name to be able to depend on it
        ['kaminari', '>= 0.16.1'],
        ['ransack', '>= 1.4.1'],
        ['bootstrap-kaminari-views', '>= 0.0.5']
      ].each do |name, *args|
        unless gemfile_contents.match(/gem ['"]#{ name }['"]/)
          gem name, *args
        end
      end
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end

    def devise_install
      generate 'devise:install'
      generate 'devise', 'AdminUser'
    end

    def simple_form_install
      generate 'simple_form:install', '--bootstrap'
      generate 'simple_form_extension:install'
    end

    def migrate
      rake 'db:migrate'
    end

    def create_default_admin
      generate 'para:admin_user'
    end

    def mount_engine
      say "Mounting Para engine in routes"
      gsub_file 'config/routes.rb', /para_at.+\n/, ''
      route "para_at '/'"
    end

    def final_message
      say <<-MESSAGE

*******************************************************************************

Para was successfully installed in your app.

Please not that your should define your root path in your application routes.rb
for the Para admin panel to work :

  e.g.: root to: 'home#index'

*******************************************************************************

      MESSAGE
    end
  end
end
