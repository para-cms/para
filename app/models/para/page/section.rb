module Para
  module Page
    class Section < ActiveRecord::Base
      self.table_name = 'para_page_sections'

      acts_as_orderable

      page_relation_options = { polymorphic: true }

      # Make Rails 5+ belongs_to relation optional for the parent page, to allow
      # using sections in other contexts that directly included into pages
      #
      if ActiveRecord::Associations::Builder::BelongsTo.valid_options({}).include?(:optional)
        page_relation_options[:optional] = true
      end

      belongs_to :page, page_relation_options

      def css_class
        @css_class ||= self.class.name.demodulize.underscore.gsub(/_/, '-')
      end

      class << self

        # This method is a shortcut to create a has_one through relation
        def section_resource(*args, &block)
          _ensure_section_resource_relation
          _create_section_resource_has_one_relation_for(*args, &block)
        end

        # This method is a shortcut to create a has_many through relation
        def section_resources(*args, &block)
          _ensure_section_resources_relation
          _create_section_resource_has_many_relation_for(*args, &block)
        end

        private

        def _ensure_section_resource_relation
          return if @section_resource_already_initialized

          has_one :section_resource, -> { ordered },
                  foreign_key: 'section_id',
                  class_name: '::Para::Page::SectionResource',
                  dependent: :destroy

          accepts_nested_attributes_for :section_resource, allow_destroy: true

          @section_resource_already_initialized = true
        end

        def _ensure_section_resources_relation
          return if @section_resources_already_initialized

          has_many :section_resources, -> { ordered },
                                       foreign_key: 'section_id',
                                       class_name: '::Para::Page::SectionResource',
                                       dependent: :destroy
          accepts_nested_attributes_for :section_resources, allow_destroy: true

          @section_resources_already_initialized = true
        end

        def _create_section_resource_has_one_relation_for(*args, &block)
          options = args.extract_options!

          # Allow using :class_name option instead of :source_type to feel more
          # like a direct has_many relation macro, and try to deduce the target
          # class name from the relation name.
          target_class_name = options.fetch(:class_name) do
            args.first.to_s.singularize.camelize
          end

          # Fill the through relation options but let the user override them
          options.reverse_merge!(
            through: :section_resource,
            source: :resource,
            source_type: target_class_name
          )

          has_one(*args, options, &block)
        end

        def _create_section_resource_has_many_relation_for(*args, &block)
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
