module Para
  module Config
    mattr_accessor :authenticate_admin_method
    @@authenticate_admin_method = :authenticate_admin_user!

    mattr_accessor :current_admin_method
    @@current_admin_method = :current_admin_user
  end
end
