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

      def render
        Tempfile.new([name, extension]).tap do |file|
          file.binmode if binary?
          file.write(generate)
          file.rewind
        end
      end

      def generate
        fail NotImplementedError
      end

      # Default to writing string data to the exported file, allowing
      # subclasses to write binary data if needed
      def binary?
        false
      end

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
          model.ransack(options[:search]).result
        else
          model.all
        end
      end

      def encode(string)
        string.presence && string.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
      end

      # Override in subclass to add a params whitelist that are fetched from
      # the request before initializing the exporter
      #
      # For example, if you want to export posts for a given category, you
      # can add the `:category_id` param to your export link, and whitelist
      # this param here with :
      #
      #   def self.params_whitelist
      #     [:category_id]
      #   end
      #
      # It will be passed from the controller to the importer so it can be used
      # to scope resources before exporting.
      #
      # Note that you'll manually need to scope the resources by overriding the
      # #resources method.
      #
      # If you need automatic scoping, please use the `:q` param that accepts
      # ransack search params and applies it to the resources.
      #
      def self.params_whitelist
        []
      end

      def params
        @params ||= options.delete(:params)
      end
    end
  end
end
