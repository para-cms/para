module Para
  module Admin
    class ExportsController < Para::Admin::JobsController
      layout false

      before_action :load_exporter

      def create
        job = @exporter.perform_later(
          model_name: @component.try(:model).try(:name),
          search: params[:q]
        )

        track_job(job)
      end

      private

      def load_exporter
        exporter_name = params[:exporter]

        @exporter = @component.exporters.find do |exporter|
          exporter.name == exporter_name
        end

        unless @exporter
          raise "Requested exporter (#{ exporter_name }) not found for " +
                ":#{ @component.identifier } component."
        end
      end
    end
  end
end
