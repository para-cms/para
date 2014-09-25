module Para
  module ApplicationHelper
    # Converts flash types to :success or :error to conform to what
    # twitter bootstrap can handle
    #
    def homogenize_flash_type type
      case type
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

    def searchable_attributes(attributes)
      attributes.select do |attr|
        [:string, :text].include?(attr.type.to_sym)
      end.map(&:name).join('_or_')
    end

    def find_table_partial_for(relation)
      if lookup_context.find_all("admin/#{relation}/_table").any?
        "admin/#{relation}/table"
      else
        'para/admin/resources/table'
      end
    end

    def attribute_field_mappings_for(component, relation)
      model = relation_klass_for(component, relation)
      Para::AttributeFieldMappings.new(model).fields
    end

    def relation_klass_for(component, relation)
      component.class.reflections[relation.to_sym].klass
    end

    def display_flash
      # Get devise errors if present
      if respond_to?(:devise_error_messages!)
        flash[:alert] = devise_error_messages! if defined?(resource) && devise_error_messages! != ""
      end

      # Render empty string if no flash
      return "" if flash.empty?

      # Make a div.alert for each message and join the whole
      messages = flash.map do |type, message|
        flash.delete(type)
        content_tag :div, class: "alert alert-block alert-#{ homogenize_flash_type(type) } alert-dismissable" do
          buffer  = content_tag(:button, type: "button", class: "close", "data-dismiss" => "alert") do
            content_tag(:span, '&times;'.html_safe)
          end
          buffer += content_tag(:div, class: "alert-icon-container pull-left") do
            content_tag(:i, "", class: "fa #{ icon_class_for(type) }")
          end
          buffer += content_tag(:p, message.html_safe)
        end
      end

      # Join the messages and make sure markup is correctly displayed
      messages.join.html_safe
    end
  end
end
