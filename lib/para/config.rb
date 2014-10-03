module Para
  module Config
    mattr_accessor :authenticate_admin_method
    @@authenticate_admin_method = :authenticate_admin_user!

    mattr_accessor :current_admin_method
    @@current_admin_method = :current_admin_user

    mattr_accessor :pagination_theme
    @@pagination_theme = 'twitter-bootstrap-3'

    mattr_accessor :admin_title
    @@admin_title = nil
  end
end
