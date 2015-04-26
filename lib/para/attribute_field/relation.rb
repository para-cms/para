module Para
  module AttributeField
    class RelationField < AttributeField::Base
      private

      def reflection
        @reflection ||= model.reflect_on_association(name)
      end

      def foreign_key
        @foreign_key ||= reflection.try(:foreign_key)
      end

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
