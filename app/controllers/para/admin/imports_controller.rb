module Para
  module Admin
    class ImportsController < Para::Admin::ComponentController
      include Para::Admin::ResourceControllerConcerns

      layout false

      before_action :load_importer

      def show
        @status = ActiveJob::Status.get(params[:id])

        respond_to do |format|
          format.json do
            if @status.failed?
              render json: { status: @status.status }, status: 422
            else
              render json: { status: @status.status, progress: @status.progress * 100 }
            end
          end

          format.html
        end
      end

      def new
        @file = Para::Library::File.new
        @model = resource_model
      end

      def create
        @file = Para::Library::File.new(file_params)

        if @file.save
          job = @importer.perform_later(@file)
          @status = ActiveJob::Status.get(job)

          render 'show'
        else
          render 'new'
        end
      end

      private

      def load_importer
        importer_name = params[:importer]&.camelize

        @importer = @component.importers.find do |importer|
          importer.name == importer_name
        end

        unless @importer
          raise "Requested importer (#{ importer_name }) not found for " +
                ":#{ @component.identifier } component."
        end
      end

      def file_params
        @file_params ||= if params[:file]
          params.require(:file).permit(:attachment)
        else
          {}
        end
      end
    end
  end
end
