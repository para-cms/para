module Para
  module SearchHelper
    def searchable_attributes(attributes)
      attributes.select do |attr|
        [:string, :text].include?(attr.type.to_sym)
      end.map(&:name).join('_or_')
    end

    def fulltext_search_param_for(attributes)
      "#{ searchable_attributes(attributes) }_cont"
    end
  end
end