module Para
  module Admin
    class SearchController < ApplicationController
      def index
        # Parse ids that are provided as string into array
        if params[:q] && params[:q][:id_in].is_a?(String)
          params[:q][:id_in] = params[:q][:id_in].split(',')
        end

        model = params[:model_name].constantize
        @results = model.ransack(params[:q]).result

        render layout: false
      end
    end
  end
end
