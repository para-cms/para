module Para
  module Component
    class Crud < Para::Component::Resource
      register :crud, self

      configurable_on :model_type, as: :selectize, collection: :available_models
    end
  end
end
