module Para
  module AttributeField
    class BooleanField < AttributeField::Base
      def value_for(instance)
        I18n.t("para.types.boolean.#{ (!!instance.send(name)).to_s }")
      end
    end
  end
end
