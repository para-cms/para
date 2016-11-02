# This class serves as a basic superclass for tabular data specific exports,
# which are organized as tables : a header row and several rows of data.
#
# This allows to only define the `#fields` method in the subclass and let the
# exporter work alone
#
module Para
  module Exporter
    class Table < Para::Exporter::Base
      def headers
        fields.map do |field|
          encode(model.human_attribute_name(field))
        end
      end

      def row_for(resource)
        fields.map do |field|
          encode(resource.send(field))
        end
      end
    end
  end
end
