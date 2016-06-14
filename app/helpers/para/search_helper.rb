module Para
  module SearchHelper
    def fulltext_search_param_for(attributes)
      "#{ searchable_attributes(attributes) }_cont"
    end

    def filtered?(attributes)
      params[:q] && params[:q][fulltext_search_param_for(attributes)].present?
    end

    def searchable_attributes(attributes)
      whitelist = attributes.select do |attribute|
        [:string, :text].include?(attribute.type.to_sym) &&
          !attribute.name.match(/password/)
      end

      whitelist.map do |attribute|
        attribute.attribute_column_path.join('_')
      end.join('_or_')
    end

    def distinct_search_results(search)
      Para::Search::Distinct.new(search).result
    end
  end
end
