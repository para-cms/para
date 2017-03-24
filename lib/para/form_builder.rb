require 'simple_form/form_builder'

require 'para/form_builder/attributes_mappings_tracker'
require 'para/form_builder/containers'
require 'para/form_builder/field_mappings'
require 'para/form_builder/nested_form'
require 'para/form_builder/ordering'
require 'para/form_builder/settings'
require 'para/form_builder/tabs'

# We'll implement our own form builder later, but for now it would need to
# patch or override Cocoon to allow creating nested fields with our custom
# form builder instead of `simple_fields_for` which uses SimpleForm::FormBuilder
# explicitly
#
SimpleForm::FormBuilder.class_eval do
  include Para::FormBuilder::AttributesMappingsTracker
  include Para::FormBuilder::Containers
  include Para::FormBuilder::FieldMappings
  include Para::FormBuilder::NestedForm
  include Para::FormBuilder::Ordering
  include Para::FormBuilder::Settings
  include Para::FormBuilder::Tabs
end

# Map IP Address fields to string
SimpleForm::FormBuilder.map_type(:inet, to: SimpleForm::Inputs::StringInput)
