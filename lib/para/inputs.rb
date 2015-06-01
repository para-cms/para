module Para
  module Inputs
    extend ActiveSupport::Autoload

    autoload :NestedOneInput
    autoload :NestedManyInput
    autoload :HasOneInput
  end
end

SimpleForm.custom_inputs_namespaces << 'Para::Inputs'
