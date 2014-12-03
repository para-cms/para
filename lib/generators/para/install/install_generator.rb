module Para
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para install generator'

    def welcome
      say 'Installing para engine ...'
    end

    def copy_initializer_file
      say 'Installing default initializer template'
      copy_file 'initializer.rb', 'config/initializers/para.rb'
    end

    def copy_migrations
      say 'Installing migrations'
      rake 'para:install:migrations'
    end

    def install_gems
      gemfile_contents = File.read(Rails.root.join('Gemfile'))

      [
        ['devise', '~> 3.0'],
        ['simple_form'],
        ['simple_form_extension'],
        ['active_decorator', github: 'glyph-fr/active_decorator', branch: 'single-table-inheritance'],
        ['paperclip', '~> 4.2'],
        ['cancancan', '~> 1.9'],
        ['friendly_id', '~> 5.0'],
        ['rolify', '~> 3.4'],
        ['kaminari', '>= 0.16.1'],
        ['ransack', '>= 1.4.1'],
        ['bootstrap-kaminari-views', '>= 0.0.5']
      ].each do |*args|
        unless gemfile_contents.match(/gem ['"]#{ name }['"]/)
          gem *args
        end
      end
    end

    def bundle_install
      say 'Bundling installed gems ...'
      puts `bundle install`
    end

    def friendly_id_install
      generate 'friendly_id'
    end

    def simple_form_install
      generate 'simple_form:install', '--bootstrap'
      generate 'simple_form_extension:install'
    end

    def cancan_install
      generate 'cancan:ability'
    end

    def devise_install
      generate 'devise:install'
      generate 'devise', 'AdminUser'
    end

    def rolify_install
      generate 'rolify Role AdminUser'
    end

    def migrate
      rake 'db:migrate'
    end

    def add_admin_user_to_ability
      inject_into_file 'app/models/ability.rb', after: '# Define abilities for the passed in user here. For example:' do
        "\n\n    if user.is_a?(AdminUser)\n      can :manage, :all\n    end\n"
      end
    end

    def create_default_admin
      generate 'para:admin_user'
    end

    def mount_engine
      mount_path = ask('Where would you like to mount Para engine ? [/]').presence || '/'
      gsub_file 'config/routes.rb', /mount Para::Engine.*\'/, ''
      route "mount Para::Engine, at: '#{mount_path.match(/^\//) ? mount_path : "/#{mount_path}"}', as: 'para'"
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
