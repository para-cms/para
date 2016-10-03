# This serves as the base controller class to create simple async ActiveJob
# tracking modals, allowing easy job launching and tracking interfaces
# implementation in Para and plugins.
#
# To use this controller, inherit from it in your app, call perform_async on an
# ActiveJob class and pass the returned job to the `#track_job(job)` method.
#
# On the client side, it is advised to use the job-tracker javascript
# plugin included into para, that will handle modal displaying and job
# status tracking automatically with Ajax requests (ActionCable may come later).
# Use a remote link or form, and add the [data-job-tracker-button] attribute,
# which will immediately handle the ajax response and display the resulting
# modal.
#
# This will render a modal and the javascript will automatically start tracking
# the job progress and refresh the view with progression, success and error
# informations
#
# Example :
#
#   class StatsGenerationController < Para::Admin::JobsController
#     def run
#       job = StatsGeneration.perform_async
#       track_job(job)
#     end
#   end
#
module Para
  module Admin
    class JobsController < Para::Admin::ComponentController
      include Para::Admin::ResourceControllerConcerns

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

          format.html do
            @job = @status[:job_type].constantize.new
            render layout: false
          end
        end
      end

      protected

      def track_job(job)
        @job = job
        @status = ActiveJob::Status.get(@job)

        render 'show', layout: false
      end
    end
  end
end
