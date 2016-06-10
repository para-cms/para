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

    # This method allows to unify search results and avoid duplicates, avoiding
    # SQL DISTINCT errors by adding ORDER BY fields to the DISTINCT selection
    # automatically
    #
    # This fixes a previous issue when trying to order search results with
    # Ransack sorting feature, when implying associated models
    #
    def distinct_search_results(results, search)
      primary_key = [search.klass.table_name, '*'].join('.')

      sorts = if search
        search.sorts.each_with_index.map do |sort, index|
          key = ['sort', index].join('_')

          [
            [sort.attr.relation.name, sort.attr.name].join('.'),
            key
          ].join(' AS ')
        end
      else
        []
      end

      selects = ([primary_key] + sorts).join(', ')

      results.select(selects).uniq
    end
  end
end
