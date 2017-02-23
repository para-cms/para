module Para
  module Admin
    module PageHelper
      def page_top_bar(options = {})
        content_tag(:div, class: 'page-title row') do
          content_tag(:h1, options[:title]) +

          if (actions = actions_for(options[:type]))
            actions.map(&method(:build_action)).join('').html_safe
          end
        end
      end

      def build_action(action)
        content_tag(:div, class: 'actions-control pull-right') do  
          link_to(action[:url], class: 'btn btn-default btn-shadow') do
            (
              (fa_icon(action[:icon], class: 'fa-fw') if action[:icon]) +
              action[:label]
            ).html_safe
          end
        end
      end

      def actions_for(type)
        Para.config.page_actions_for(type).map do |action|
          instance_eval(&action)
        end.compact
      end
    end
  end
end
