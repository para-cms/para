require 'csv'

module Para
  module Exporter
    class Csv < Base
      register_base_exporter :csv, self

      def extension
        'csv'
      end

      def mime_type
        'text/csv'
      end

      def render
        CSV.generate(col_sep: ";", row_sep: "\r\n") do |csv|
          csv << headers

          resources.each do |resource|
            csv << row_for(resource)
          end
        end
      end

      private

      def headers
        fields.map do |field|
          encode(User.human_attribute_name(field))
        end
      end

      def row_for(resource)
        fields.map do |field|
          encode(resource.send(field))
        end
      end

      def encode(string)
        string.presence && string.to_s.encode('Windows-1252')
      end
    end
  end
end
