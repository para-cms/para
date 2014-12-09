module Para
  module ModelFieldParsers
    class Redactor < Para::ModelFieldParsers::Base
      register :redactor, self

      def parse!
        %w(content description).each do |field_name|
          field = fields_hash[field_name]

          if field && field.type == :text
            fields_hash[field_name] = Para::AttributeField::Redactor.new(
              field.model, name: field_name
            )
          end
        end
      end
    end
  end
end
