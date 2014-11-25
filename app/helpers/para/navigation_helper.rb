module Para
  module NavigationHelper
    def component_section_active?(component_section)
      (@component_section && @component_section == component_section) ||
      (@component && @component.component_section_id == component_section.id)
    end
  end
end
