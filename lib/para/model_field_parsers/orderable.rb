module Para
  module ModelFieldParsers
    class Orderable < Para::ModelFieldParsers::Base
      register :orderable, self

      def parse!
        fields_hash.delete(:position)
      end

      def applicable?
        model.orderable?
      end
    end
  end
end
