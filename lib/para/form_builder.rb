require 'simple_form/form_builder'

require 'para/form_builder/field_mappings'
require 'para/form_builder/nested_form'
require 'para/form_builder/ordering'

# We'll implement our own form builder late, but for now it would need to
# patch or override Cocoon to allow creating nested fields with our custom
# fields builder
SimpleForm::FormBuilder.class_eval do
  include Para::FormBuilder::FieldMappings
  include Para::FormBuilder::NestedForm
  include Para::FormBuilder::Ordering
end
