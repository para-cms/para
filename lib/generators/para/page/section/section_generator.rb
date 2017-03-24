module Para
  module Page
    class SectionGenerator < Rails::Generators::NamedBase
      include Para::Generators::NameHelpers

      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, type: :array, required: false, default: []

      def generate_model
        template(
          "section.rb.erb",
          "app/models/page_section/#{ singular_namespaced_path }.rb"
        )
      end

      def generate_fields
        generate 'para:nested_fields', "page_section/#{ singular_namespaced_path }"
      end

      def generate_template
        template(
          "section.html.haml.erb",
          "app/views/page_section/#{ plural_namespaced_path }/_#{ singular_namespaced_path }.html.haml"
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
