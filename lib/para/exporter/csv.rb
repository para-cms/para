require 'csv'

module Para
  module Exporter
    class Csv < Table
      protected

      def generate
        CSV.generate do |csv|
          csv << headers

          resources.each do |resource|
            csv << row_for(resource)
            progress!
          end
        end
      end

      def extension
        '.csv'
      end
    end
  end
end
