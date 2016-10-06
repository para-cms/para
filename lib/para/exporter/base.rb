module Para
  module Exporter
    class Base < Para::Job::Base
      attr_reader :name, :model, :options

      def perform(model_name: nil, **options)
        @model = model_name && model_name.constantize
        @options = options
        @name = model.try(:model_name).try(:route_key).try(:parameterize)

        # Render file and store it in a Library::File object, allowing us
        # to retrieve that file easily from the job and subsequent requests
        #
        file = Para::Library::File.create!(attachment: render)
        store(:file_gid, file.to_global_id)
      end

      def file
        @file ||= GlobalID::Locator.locate(store(:file_gid))
      end

      def file_name
        @file_name ||= [name, extension].join
      end

      private

      def total_progress
        resources.length
      end

      # Allow passing a `:resources` option or a ransack search hash to filter
      # exported resources
      #
      def resources
        @resources ||= if options[:resources]
          options[:resources]
        elsif options[:search]
          model.search(options[:search]).result
        else
          model.all
        end
      end
    end
  end
end
