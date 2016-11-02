module Para
  module Page
    class Section < ActiveRecord::Base
      self.table_name = 'para_page_sections'

      acts_as_orderable

      belongs_to :page, polymorphic: true

      def css_class
        @css_class ||= self.class.name.demodulize.underscore.gsub(/_/, '-')
      end
    end
  end
end
