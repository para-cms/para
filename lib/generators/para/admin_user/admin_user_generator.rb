module Para
  class AdminUserGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def create_admin_user
      say 'Creating default super admin...'

      email =    ask('Email    [admin@example.com] : ').presence || 'admin@example.com'
      password = ask('Password [password]          : ').presence || 'password'

      admin = AdminUser.create!(email: email, password: password)
      admin.add_role(:super_admin)

      say 'Created AdminUser'
    end
  end
end
