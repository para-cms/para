module Para
  module Logging
    class ActiveJobLogSubscriber < ActiveSupport::LogSubscriber
      def failed(event)
        fatal do
          job = event.payload[:job]
          buffer = []
          buffer << "#{ job.class.name } (Job ID: #{ job.job_id }) failed" + args_info(job)
          buffer << ''
          buffer << [event.payload[:exception].class, event.payload[:exception].message].join(' - ')
          buffer << ''
          buffer << '-------------------'
          buffer << ''
          buffer += event.payload[:exception].backtrace
          buffer << ''
          buffer.compact.join("\n")
        end
      end

      private

      def args_info(job)
        if job.arguments.any?
          ' with arguments: ' +
            job.arguments.map { |arg| format(arg).inspect }.join(', ')
        end
      end

      def format(arg)
        case arg
        when Hash
          arg.transform_values { |value| format(value) }
        when Array
          arg.map { |value| format(value) }
        when GlobalID::Identification
          arg.to_global_id rescue arg
        else
          arg
        end
      end

      def logger
        ActiveJob::Base.logger
      end
    end
  end
end

