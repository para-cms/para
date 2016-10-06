module Para
  module Job
    class Base < ActiveJob::Base
      include ActiveJob::Status
      # Used to store import errors on the object
      include ActiveModel::Validations
      # Used to translate importer name with rails default `activemodel` i18n keys
      extend  ActiveModel::Translation

      before_perform :store_job_type

      protected

      def store_job_type
        status.update(job_type: self.class.name)
      end

      def progress!
        ensure_total_progress
        progress.increment
      end

      def save_errors!
        status.update(errors: errors.full_messages)
      end

      # Default total progress to nil, making the UI show an animated porgress
      # bar, indicating work is in progress, but not the exact progress
      def total_progress
        nil
      end

      def ensure_total_progress
        return if @total_progress

        @total_progress ||= if respond_to?(:progress_total)
          progress.total = progress_total
        else
          progress[:total]
        end
      end

      def store(key, value = nil)
        if value
          status.update(key => value)
        else
          status[key]
        end
      end
    end
  end
end

