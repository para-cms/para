module Admin
  class <%= plural_file_name.camelize %>Controller < Para::Admin::ResourcesController
    load_and_authorize_resource :<%= file_name %>

    def resource
      @<%= file_name %>
    end
  end
end
