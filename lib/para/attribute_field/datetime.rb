module Para
  module AttributeField
    class DatetimeField < AttributeField::Base
      register :datetime, :date, self

      field_option :wrapper, :wrapper_name

      def value_for(instance)
        (value = instance.send(name)) && I18n.l(value)
      end

      def wrapper_name
        :horizontal_form
      end
    end
  end
end
