module Para
  module Component
    class %{name}Controller < Para::Admin::ComponentController
      def show
        @%{plurale} = @component.activities
      end
    end
  end
end