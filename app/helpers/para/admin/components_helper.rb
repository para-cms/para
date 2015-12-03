module Para
  module Admin::ComponentsHelper
    def ordered_components
      @component_sections.each_with_object([]) do |section, components|
        section.components.each do |component|
          components << component
        end
      end.sort_by(&:updated_at)
    end
  end
end
