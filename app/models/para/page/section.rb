module Para
  module Page
    class Section < ActiveRecord::Base
      self.table_name = 'para_page_sections'

      include Para::Sti::RootModel

      acts_as_orderable

      belongs_to :page, polymorphic: true

      def self.subclasses_namespace
        'PageSection'
      end

      def css_class
        @css_class ||= self.class.name.demodulize.underscore.gsub(/_/, '-')
      end
    end
  end
end
