module Para
  module AttributeField
    class BelongsToField < RelationField
      field_option :collection, :relation_options

      def field_name
        reflection.foreign_key
      end

      def value_for(instance)
        if (resource = instance.send(name))
          resource_name(resource)
        end
      end

      def relation_options
        reflection.klass.all
      end

      def parse_input(params)
        if (id = params[reflection.foreign_key].presence) && !reflection.klass.exists?(id: id)
          resource = reflection.klass.new

          Para.config.resource_name_methods.each do |method_name|
            setter_name = :"#{ method_name }="

            if resource.respond_to?(setter_name)
              resource.send(setter_name, id)

              if resource.save
                params[reflection.foreign_key] = resource.id
                break
              end
            end
          end
        end
      end
    end
  end
end
