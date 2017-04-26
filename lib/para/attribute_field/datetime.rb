module Para
  module AttributeField
    class DatetimeField < AttributeField::Base
      register :datetime, :date, self

      field_option :wrapper, :wrapper_name

      def value_for(instance)
        (value = instance.send(name)) && ::I18n.l(value, format: :admin)
      end

      def wrapper_name
        :vertical_form
      end
    end
  end
end
