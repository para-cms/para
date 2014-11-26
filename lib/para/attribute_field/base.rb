module Para
  module AttributeField
    class Base
      attr_reader :model, :name, :type, :field_type, :field_method

      def initialize(model, options = {})
        @model = model
        @name = options[:name]
        @type = options[:type]
        @field_type = options[:field_type]

        determine_name_and_field_method!
      end

      def determine_name_and_field_method!
        name = @name

        reference = model.reflect_on_all_associations.find do |association|
          association.foreign_key == name
        end

        if reference
          @name = reference.name
          @field_method = :association
        else
          @name = name
          @field_method = :input
        end
      end

      def value_for(instance)
        instance.send(name)
      end
    end
  end
end
