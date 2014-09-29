module Para
  class ComponentSection < ActiveRecord::Base
    has_many :components, class_name: 'Para::Component::Base', autosave: true,
             foreign_key: :component_section_id,
             dependent: :destroy
  end
end
