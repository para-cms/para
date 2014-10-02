module Para
  module Inputs
    extend ActiveSupport::Autoload

    autoload :NestedManyInput
  end
end

SimpleForm.custom_inputs_namespaces << 'Para::Inputs'
