module Para
  module Importer
    class Base < ActiveJob::Base
      include ActiveJob::Status

      # Used to store import errors on the object
      include ActiveModel::Validations
      # Used to translate importer name with rails default `activemodel` i18n keys
      extend  ActiveModel::Naming

      rescue_from Exception, with: :rescue_exception

      class_attribute :allows_import_errors

      attr_reader :file, :sheet

      def perform(file, options = {})
        @file = file
        @sheet = Roo::Spreadsheet.open(file.attachment.path, options)
        progress.total = sheet.last_row - 1

        ActiveRecord::Base.transaction do
          (2..(sheet.last_row)).each do |index|
            begin
              progress.increment
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

        status.update(errors: errors.full_messages)
      end

      private

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

      def rescue_exception(exception)
        Rails.logger.fatal [exception.class.name, exception.message].join(' - ')

        if defined?(ExceptionNotifier)
          ExceptionNotifier.notify_exception(
            exception, data: {
              importer: self.class.name,
              payload: {
                file_type: file.class,
                file_id: file.id,
                file_name: file.attachment_file_name
              }
            }
          )
        end

        raise exception
      end
    end
  end
end
