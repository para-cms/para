module Para
  module Job
    class Base < ActiveJob::Base
      include ActiveJob::Status
      # Used to store job errors on the object
      include ActiveModel::Validations
      # Used to translate job name with rails default `activemodel` i18n keys
      extend  ActiveModel::Translation

      rescue_from Exception, with: :rescue_exception

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

      def rescue_exception(exception)
        status.update(status: :failed)

        tag_logger(self.class.name, job_id) do
          ActiveSupport::Notifications.instrument "failed.active_job",
              adapter: self.class.queue_adapter, job: self, exception: exception
        end

        if defined?(ExceptionNotifier)
          ExceptionNotifier.notify_exception(
            exception, data: { job: self.class.name, payload: arguments }
          )
        end

        raise exception
      end
    end
  end
end

