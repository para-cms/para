module Para
  module AttributeField
    class RelationField < AttributeField::Base
      include Para::Helpers::ResourceName

      def reflection
        @reflection ||= model.reflect_on_association(name)
      end

      def foreign_key
        @foreign_key ||= reflection && case reflection.macro
        when :belongs_to then reflection.foreign_key
        when :has_one then :"#{ reflection.name }_id"
        when :has_many then :"#{ reflection.name.to_s.singularize }_ids"
        end
      end

      def through_relation
        @through_relation ||= reflection.options[:through]
      end

      def through_reflection
        @through_reflection ||= through_relation && model.reflect_on_association(through_relation)
      end

      def through_relation_source_foreign_key
        @through_relation_source_foreign_key ||= reflection.source_reflection.foreign_key
      end

      def polymorphic_through_reflection?
        !!(through_relation && reflection.source_reflection.options[:polymorphic])
      end

      private

      def resource_name(resource)
        Para.config.resource_name_methods.each do |method|
          return resource.send(method) if resource.respond_to?(method)
        end

        model_name = resource.class.model_name.human
        "#{ model_name } - #{ resource.id }"
      end

      # Takes an array of ids and a block. Check for each id if model exists
      # and create one if not. E.g: [12, "foo"] will try to create a model with
      # 'foo'
      def on_the_fly_creation ids, &block
        Array.wrap(ids).each do |id|
          if !reflection.klass.exists?(id: id)
            resource = reflection.klass.new

            Para.config.resource_name_methods.each do |method_name|
              setter_name = :"#{ method_name }="

              if resource.respond_to?(setter_name)
                resource.send(setter_name, id)

                if resource.save
                  block.call(resource, id)
                  break
                end
              end
            end
          end
        end
      end
    end
  end
end
