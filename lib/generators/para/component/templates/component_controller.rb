module Admin
  class <%= class_name %>ComponentController < Para::Admin::ComponentController
    def show
      # @<%= plural_file_name %> = @component.resources
    end
  end
end
