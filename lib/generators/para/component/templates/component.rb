module Para
  module Component
    class %{name} < Para::Component::Base
      register :%{sym}, self

      # ADD HERE RELATED RESOURCE
      # EXAMPLE:
      #
      #   has_many :resources, dependent: :destroy
      #
    end
  end
end
