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
        ['simple_form', '3.1.0.rc2'],
        ['simple_form_extension'],
        ['paperclip', '~> 4.2'],
        ['cancancan', '~> 1.9'],
        ['friendly_id', '~> 5.0']
      ].each do |name, version|
        unless gemfile_contents.match(/gem ['"]#{ name }['"]/)
          gem(name, version)
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
  end
end
