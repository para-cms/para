module Para
  module Admin
    module HistoryHelper
      def history_for(component, action:, **options)
        return unless component.history?

        partial_path = find_partial_for(
          (options[:resource] || options[:relation]),
          "history/#{ action }"
        )

        render partial: partial_path, locals: options
      end
    end
  end
end
