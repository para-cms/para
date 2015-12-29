module Para
  module Importer
    class Base
      attr_reader :sheet

      def initialize(file)
        @sheet = Roo::Spreadsheet.open(file.path)
      end

      def run
        ActiveRecord::Base.transaction do
          (2..(sheet.last_row)).each do |index|
            import_from_row(sheet.row(index))
          end
        end
      end

      def import_from_row(row)
        raise '#import_from_row(row) must be defined'
      end
    end
  end
end
