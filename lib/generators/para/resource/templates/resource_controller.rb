module Admin
  class <%= plural_file_name.camelize %>Controller < Para::Admin::ResourcesController
    resource :<%= file_name %>
  end
end
