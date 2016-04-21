module Para
  module Page
    class SectionGenerator < Rails::Generators::NamedBase
      include Para::Generators::NameHelpers

      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, type: :array

      def generate_form
        template(
          "section.rb.erb",
          "app/models/page_section/#{ plural_namespaced_path }.rb"
        )
      end

      private

      def attributes_separated_with_commas
        if attributes.empty?
          ':title'
        else
          attributes.map { |attribute| ":#{ attribute.name }" }.join(', ')
        end
      end
    end
  end
end
