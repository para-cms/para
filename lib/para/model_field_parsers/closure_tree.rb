module Para
  module ModelFieldParsers
    class ClosureTree < Para::ModelFieldParsers::Base
      register :closure_tree, self

      def parse!
        hidden_fields.each(&fields_hash.method(:delete))
      end

      def applicable?
        model.respond_to? :roots
      end

      private

      def hidden_fields
        [
          :ancestor_hierarchies,
          :self_and_ancestors,
          :descendant_hierarchies,
          :self_and_descendants
        ]
      end
    end
  end
end
