module Admin
  class %{name}ComponentController < Para::Admin::ComponentController
    def show
      @%{plural} = @component.activities
    end
  end
end
