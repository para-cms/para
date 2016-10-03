module Para
  module Job
    class Base < ActiveJob::Base
      include ActiveJob::Status
      # Used to store import errors on the object
      include ActiveModel::Validations
      # Used to translate importer name with rails default `activemodel` i18n keys
      extend  ActiveModel::Naming

      before_perform do |job|
        job.status.update(job_type: job.class.name)
      end

      protected

      def progress!
        ensure_total_progress
        progress.increment
      end

      def save_errors!
        status.update(errors: errors.full_messages)
      end

      def ensure_total_progress
        return if @total_progress

        @total_progress ||= if respond_to?(:progress_total)
          progress.total = progress_total
        else
          progress[:total]
        end
      end
    end
  end
end

