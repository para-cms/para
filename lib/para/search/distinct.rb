# This class allows to unify search results and avoid duplicates, avoiding
# SQL DISTINCT errors by adding ORDER BY fields to the DISTINCT selection
# automatically
#
# This fixes a previous issue when trying to order search results with
# Ransack sorting feature, when implying associated models
#
module Para
  module Search
    class Distinct
      attr_reader :search

      def initialize(search)
        @search = search
        @sort_index ||= 0
      end

      def result
        selects = build_selects
        search.result.select(selects).distinct
      end

      private

      def build_selects
        ([table_wildcard_select] + sort_selects).join(', ')
      end

      def table_wildcard_select
        [search.klass.table_name, '*'].join('.')
      end

      def sort_selects
        return [] unless search

        search.sorts.map do |sort|
          case sort.attr
          when Arel::Attributes::Attribute then process_attribute(sort)
          when Arel::Nodes::SqlLiteral then process_sql_literal(sort)
          #
          # Explicitly raise here to avoid the system to swallow sorting errors,
          # since any unsupported class must have been explicitly used by the
          # developer, and debugging it would be hard without an exception
          #
          else raise "Unsupported sort attribute class : #{ sort.attr.class.name }"
          end
        end
      end

      def process_attribute(sort)
        sort_index = next_sort_index
        sql = [sort.attr.relation.name, sort.attr.name].join('.')

        replace_sort(sort, sort_index)
        build_alias(sql, sort_index)
      end

      # When given an SQL literal, we store the sql expression in a named SELECT
      # variable, and replace the expression by its variable name inside of the
      # ransack sort instance
      #
      def process_sql_literal(sort)
        sort_index = next_sort_index
        sql = sort.attr.to_s

        replace_sort(sort, sort_index)
        build_alias(sql, sort_index)
      end

      def next_sort_index
        ['sort', @sort_index += 1].join('_')
      end

      def replace_sort(sort, sort_index)
        sort.instance_variable_set(:@attr, Arel::Nodes::SqlLiteral.new(sort_index))
      end

      def build_alias(sql, index)
        Arel::Nodes::InfixOperation.new(
          'AS',
          format_string(sql),
          Arel::Nodes::SqlLiteral.new(index)
        ).to_sql
      end

      def format_string(sql)
        sql_lower(sql_unaccent(sql_stringify(sql)))
      end

      def sql_lower(sql)
        Arel::Nodes::NamedFunction.new('LOWER', [sql])
      end

      def sql_unaccent(sql)
        Arel::Nodes::NamedFunction.new('UNACCENT', [sql])
      end

      def sql_stringify(sql)
        Arel::Nodes::NamedFunction.new(
          'CAST', [
            Arel::Nodes::InfixOperation.new(
              'AS',
              Arel::Nodes::SqlLiteral.new(sql),
              Arel::Nodes::SqlLiteral.new('text')
            )
          ]
        )
      end
    end
  end
end
