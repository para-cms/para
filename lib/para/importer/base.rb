module Para
  module Importer
    class Base < Para::Job::Base
      class_attribute :allows_import_errors

      attr_reader :file, :sheet

      def perform(file, options = {})
        @file = file
        options.reverse_merge!(extension: file.attachment_ext)
        @sheet = Roo::Spreadsheet.open(file.attachment_path, options)

        ActiveRecord::Base.transaction do
          (2..(sheet.last_row)).each do |index|
            begin
              progress!
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

        save_errors!

        # Ensure that `.perform_now` returns the importer
        self
      end

      protected

      def total_progress
        sheet.last_row - 1
      end

      def import_from_row(row)
        raise '#import_from_row(row) must be defined'
      end

      def add_errors_from(index, record)
        # The file's row number starts at 1 and headers are striped, so we
        # add 2 to the index to obtain the row number
        row_name = I18n.t('para.import.row_error_prefix', number: index)

        record.errors.messages.each do |attribute, messages|
          messages.each do |message|
            full_message = record.errors.full_message(attribute, message)

            if (value = record.send(attribute)).presence
              full_message << ' (<b>' <<  value << '</b>)'
            end

            errors.add(row_name, full_message)
          end
        end
      end

      def allows_import_errors?
        !!self.class.allows_import_errors
      end

      def self.allow_import_errors!
        self.allows_import_errors = true
      end

      def headers
        @headers ||= sheet.row(1)
      end
    end
  end
end
