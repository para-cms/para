module Para
  module Admin::ComponentsHelper
    def ordered_components
      @component_sections.each_with_object([]) do |section, components|
        section.components.each do |component|
          components << component if can?(:read, component)
        end
      end.sort_by(&:name)
    end
  end
end
