module Para
  module AttributeField
    class EnumField < AttributeField::Base
      register :enum, self

      def value_for(instance)
        if (raw_value = instance.send(name)) &&
          path = enum_path_for(instance, raw_value)
          translation = ::I18n.t("activerecord.#{ path }", default: false)

          translation || raw_value
        end
      end

      private

      def enum_path_for(instance, key)
        ['enums', instance.class.model_name.i18n_key, name, key].join('.')
      end
    end
  end
end
