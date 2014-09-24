module Para
  module Component
    class <%= class_name %> < Para::Component::Base
      register :<%= file_name %>, self

      # ADD HERE RELATED RESOURCE
      # EXAMPLE:
      #
      #   has_many :resources, dependent: :destroy
      #
    end
  end
end
