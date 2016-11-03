module Para
  class AdminUserGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def create_admin_user
      say 'Creating default admin...'

      email =    ask('Email    [admin@example.com] : ').presence || 'admin@example.com'
      password = ask('Password [password]          : ', echo: false).presence || 'password'
      print "\n" # echo: false doesn't print a newline so we manually add it

      AdminUser.create! email: email, password: password

      say 'Created AdminUser'
    end
  end
end
