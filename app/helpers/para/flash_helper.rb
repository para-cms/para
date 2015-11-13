module Para
  module FlashHelper
    def display_admin_flash
      # Render empty string if no flash
      return "" if flash.empty?

      # Make a div.alert for each message and join the whole
      messages = flash.map do |type, message|
        flash.delete(type)
        type = homogenize_flash_type(type)

        icon = content_tag(:div, class: "alert-icon-container pull-left") do
          content_tag(:i, "", class: "fa #{ icon_class_for(type) }") +
          '&nbsp;'.html_safe
        end

        alert(type: type) do
          icon + content_tag(:p, message.html_safe)
        end
      end

      # Join the messages and make sure markup is correctly displayed
      messages.join.html_safe
    end

    private

    # Converts flash types to :success or :error to conform to what
    # twitter bootstrap can handle
    #
    def homogenize_flash_type type
      case type.to_sym
      when :notice then :success
      when :alert then :warning
      when :error then :danger
      else type
      end
    end

    def icon_class_for type
      case type
      when :success then "fa-check"
      when :error then "fa-warning"
      else "fa-exclamation-triangle"
      end
    end
  end
end
