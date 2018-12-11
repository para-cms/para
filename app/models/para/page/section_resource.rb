module Para
  module Page
    class SectionResource < ActiveRecord::Base
      self.table_name = 'para_page_section_resources'

      acts_as_orderable parent: :section, as: :section_resources

      belongs_to :section
      belongs_to :resource, polymorphic: true
    end
  end
end
