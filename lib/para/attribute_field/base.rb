module Para
  module AttributeField
    class Base
      class_attribute :_field_options

      attr_reader :model, :name, :type, :field_type, :field_method

      def self.field_option(key, method_name, options = {})
        self._field_options ||= []

        self._field_options += [{
          key: key,
          method_name: method_name,
          options: options
        }]
      end

      field_option :as, :field_type_name

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

      # Allows parsing input params before they're passed to the model, so
      # it can be easy to edit them according to some field type specific
      # behavior
      #
      def parse_input(params); end

      def field_options
        self.class._field_options.each_with_object({}) do |params, hash|
          value = send(params[:method_name])
          hash[params[:key]] = value if value != nil || params[:options][:allow_nil]
        end
      end

      def field_name
        name
      end

      private

      def field_type_name
        field_type.presence && field_type.to_sym
      end
    end
  end
end
