module Para
  module Admin
    class SearchController < ApplicationController
      include Para::Helpers::ResourceName

      def index
        # Parse ids that are provided as string into array
        if params[:q] && params[:q][:id_in].is_a?(String)
          params[:q][:id_in] = params[:q][:id_in].split(',')
        end

        model = params[:model_name].constantize
        @results = model.ransack(params[:q]).result
        @results = @results.limit(params[:limit]) if params[:limit]

        case params[:mode]
        when "selectize"
          render json: @results.map { |res|
            { text: resource_name(res), value: res.id }
          }
        else
          render layout: false
        end
      end
    end
  end
end
