module Para
  class ComponentResource < ActiveRecord::Base
    belongs_to :component, class_name: 'Para::Component::Base'
    belongs_to :resource, polymorphic: true
  end
end
