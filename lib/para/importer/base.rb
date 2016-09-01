module Para
  module Importer
    class Base
      include ActiveModel::Validations

      class_attribute :allows_import_errors

      attr_reader :sheet

      def initialize(file, options = {})
        @sheet = Roo::Spreadsheet.open(file.path, options)
      end

      def run
        ActiveRecord::Base.transaction do
          (2..(sheet.last_row)).each do |index|
            begin
              import_from_row(sheet.row(index))
            rescue ActiveRecord::RecordInvalid => error
              if allows_import_errors?
                add_errors_from(index, error.record)
              else
                raise
              end
            end
          end
        end
      end

      private

      def import_from_row(row)
        raise '#import_from_row(row) must be defined'
      end

      def add_errors_from(index, record)
        # The file's row number starts at 1 and headers are striped, so we
        # add 2 to the index to obtain the row number
        row_name = I18n.t('para.import.row_error_prefix', number: index)

        record.errors.full_messages.each do |message|
          errors.add(row_name, message)
        end
      end

      def allows_import_errors?
        !!self.class.allows_import_errors
      end

      def self.allow_import_errors!
        self.allows_import_errors = true
      end
    end
  end
end
