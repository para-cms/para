module Para
  module Helpers
    module AttributesMappings
      def attributes_mappings_for(params)
        if (data = params.delete('_attributes_mappings'))
          JSON.parse(data)
        else
          {}
        end
      end
    end
  end
end
