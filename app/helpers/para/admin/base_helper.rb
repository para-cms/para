module Para
  module Admin
    module BaseHelper
      def find_partial_for(relation, partial)
        if lookup_context.find_all("admin/#{relation}/_#{ partial }").any?
          "admin/#{ relation }/#{ partial }"
        else
          "para/admin/resources/#{ partial }"
        end
      end

      def resource_title_for(resource)
        resource.try(:title) || resource.try(:name) ||
        t('para.form.shared.edit.title', model: resource.class.model_name.human)
      end

      def registered_components_options
        Para::Component.registered_components.keys.map do |identifier|
          [
            t("para.component.#{ identifier }.name", default: identifier.to_s.humanize),
            identifier
          ]
        end
      end

      def flash_message(type, resource = nil)
        key = "#{ flash_shared_key }.#{ params[:action] }.#{ type }"

        translation = if resource
          I18n.t(key, model: resource.class.model_name.human)
        else
          I18n.t(key)
        end

        flash[type] = translation
      end

      def flash_shared_key
        'para.flash.shared'
      end
    end
  end
end
