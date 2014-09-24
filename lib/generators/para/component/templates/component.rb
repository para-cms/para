module Para
  module Component
    class <%= class_name %> < Para::Component::Base
      register :<%= file_name %>, self
    end
  end
end
