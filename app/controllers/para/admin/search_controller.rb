module Para
  module Admin
    class SearchController < ApplicationController
      include Para::ModelHelper
      include Para::SearchHelper

      def index
        model = params[:model_name].constantize
        attributes = model_field_mappings(model).fields
        @results = model.search(fulltext_search_param_for(attributes) => params[:search]).result
        render layout: false
      end
    end
  end
end
