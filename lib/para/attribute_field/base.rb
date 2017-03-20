module Para
  module AttributeField
    class Base
      class_attribute :_field_options
      cattr_accessor :_field_types

      attr_reader :model, :name, :type, :field_type, :field_method, :options

      def self.field_option(key, method_name, options = {})
        self._field_options ||= []

        self._field_options += [{
          key: key,
          method_name: method_name,
          options: options
        }]
      end

      # Registers the class as the responder for a given field type
      #
      # Example :
      #
      #   # This will allow looking :my_field or :myfield up and instantiate
      #   # self as the field
      #   class MyField < Para::AttributeField::Base
      #     register :my_field, :myfield, self
      #   end
      #
      #
      def self.register(*args)
        attribute_class = args.pop

        args.each do |arg|
          Base.field_types[arg] = attribute_class
        end
      end

      def self.field_types
        @_field_types ||= {}
      end

      field_option :as, :field_type_name

      def initialize(model, options = {})
        @model = model
        @name = options.delete(:name)
        @type = options.delete(:type)
        @field_type = options.delete(:field_type)
        @options = options

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

      def excerptable_value?
        true
      end

      #
      def searchable?
        options[:searchable] != false && (
          [:string, :text].include?(type.to_sym) && !name.match(/password/)
        )
      end

      # Allows parsing input params before they're passed to the model, so
      # it can be easy to edit them according to some field type specific
      # behavior
      #
      def parse_input(params, resource); end

      def field_options
        self.class._field_options.each_with_object({}) do |params, hash|
          value = send(params[:method_name])
          hash[params[:key]] = value if value != nil || params[:options][:allow_nil]
        end
      end

      def field_name
        name
      end

      def attribute_column_path
        [name]
      end

      def type?(type)
        self.type.to_s == type.to_s
      end

      private

      def field_type_name
        field_type.presence && field_type.to_sym
      end
    end
  end
end
