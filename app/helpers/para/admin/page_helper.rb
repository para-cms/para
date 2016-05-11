module Para
  module Admin
    module PageHelper
      def page_top_bar(options = {})
        content_tag(:div, class: 'page-title') do
          content_tag(:h1, options[:title]) +

          if (actions = actions_for(options[:type]))
            content_tag(:div, class: 'page-actions') do
              actions.map(&method(:build_action)).join('').html_safe
            end
          end
        end
      end

      def build_action(action)
        link_to(action[:url], class: 'btn btn-default') do
          (
            (fa_icon(action[:icon]) if action[:icon]) +
            action[:label]
          ).html_safe
        end
      end

      def actions_for(type)
        Para.config.page_actions_for(type).map do |action|
          instance_eval(&action)
        end
      end
    end
  end
end
