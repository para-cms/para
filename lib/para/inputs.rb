module Para
  module Inputs
    extend ActiveSupport::Autoload

    autoload :NestedBaseInput
    autoload :NestedOneInput
    autoload :NestedManyInput
    autoload :MultiSelectInput
    autoload :HasOneInput
  end
end

SimpleForm.custom_inputs_namespaces << 'Para::Inputs'
