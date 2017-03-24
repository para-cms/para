module Para
  module Page
    class Section < ActiveRecord::Base
      self.table_name = 'para_page_sections'

      acts_as_orderable

      belongs_to :page, polymorphic: true

      def css_class
        @css_class ||= self.class.name.demodulize.underscore.gsub(/_/, '-')
      end

      class << self
        # This method is a shortcut to create a has_many through relation
        def section_resources(*args, &block)
          _ensure_section_resources_relation
          _create_section_resource_relation_for(*args, &block)
        end

        private

        def _ensure_section_resources_relation
          return if @section_resources_already_initialized

          has_many :section_resources, foreign_key: 'section_id',
                                       class_name: '::Para::Page::SectionResource',
                                       dependent: :destroy
          accepts_nested_attributes_for :section_resources, allow_destroy: true

          @section_resources_already_initialized = true
        end

        def _create_section_resource_relation_for(*args, &block)
          options = args.extract_options!

          # Allow using :class_name option instead of :source_type to feel more
          # like a direct has_many relation macro, and try to deduce the target
          # class name from the relation name.
          target_class_name = options.fetch(:class_name) do
            args.first.to_s.singularize.camelize
          end

          # Fill the through relation options but let the user override them
          options.reverse_merge!(
            through: :section_resources,
            source: :resource,
            source_type: target_class_name
          )

          has_many(*args, options, &block)
        end
      end
    end
  end
end
