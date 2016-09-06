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
            render json: { status: @status.status, progress: @status.progress * 100 }
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
          flash_message(:error)
          render 'new'
        end
      end

      private

      def load_importer
        @importer = @component.importers.find do |importer|
          importer.name == params[:importer]
        end
      end

      def file_params
        params.require(:file).permit(:attachment)
      end
    end
  end
end
