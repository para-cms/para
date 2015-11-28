module Para
  module AttributeField
    class DatetimeField < AttributeField::Base
      register :boolean, :bool, self

      def value_for(instance)
        (value = instance.send(name)) && I18n.l(value)
      end
    end
  end
end
