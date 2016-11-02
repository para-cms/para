require 'stringio'
require 'spreadsheet'

module Para
  module Exporter
    class Xls < Table
      protected

      def extension
        '.xls'
      end

      def name
        'export'
      end

      def mime_type
        'application/vnd.ms-excel'
      end

      def binary?
        true
      end

      def generate
        generate_workbook do |workbook|
          sheet = workbook.create_worksheet

          # Add headers
          sheet.row(0).concat headers

          # Add content rows
          resources.each_with_index do |resource , index|
            sheet.row(index + 1).concat row_for(resource)
          end
        end
      end

      def generate_workbook(&block)
        workbook = Spreadsheet::Workbook.new

        block.call(workbook)

        buffer = StringIO.new
        workbook.write(buffer)
        buffer.rewind
        buffer.read
      end

      def fields
        fail NotImplementedError
      end

      def encode(string)
        string.presence && string.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
      end
    end
  end
end
