module Para
  module Admin::ComponentsHelper
    # Return the sections / components structure, with components properly
    # decorated
    #
    def admin_component_sections
      @admin_component_sections ||= begin
        Para::ComponentSection.ordered.includes(:components).tap do |sections|
          sections.flat_map(&:components).each(&method(:decorate))
        end
      end
    end

    def ordered_components
      admin_component_sections.each_with_object([]) do |section, components|
        section.components.each do |component|
          components << component if can?(:read, component)
        end
      end.sort_by(&:name)
    end
  end
end
