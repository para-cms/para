module Para
  module Admin
    module PaginationHelper
      def page_entries(resources)
        page_entries_info(resources) + per_page_select
      end

      private

      def per_page_select
        options = [25, 50, 100, 250, 500, 1000]

        params = (Rack::Utils.parse_query(request.env['QUERY_STRING']).symbolize_keys rescue {})
        params.delete(:page)
        count_with_url = options.each_with_object({}) do |count, hash|
          query = params.merge(:per_page => count)
          url  = request.env['PATH_INFO'] + (query.empty? ? '' : "?#{query.to_query}")
      
          hash[count] = url
        end

        current_per_page = params[:per_page] || Kaminari.config.default_per_page

        render partial: 'para/admin/resources/per_page_select', locals: { 
          count_with_url: count_with_url, 
          current_per_page: current_per_page 
        }
      end
    end
  end
end
