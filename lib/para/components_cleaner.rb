module Para
  class ComponentsCleaner
    # Hide class instanciation
    def self.run; new.run; end

    def run
      components.each do |component|
        unless component == Para.components.component_for(component.identifier)
          component.destroy
        end
      end

      Para::ComponentSection.find_each do |section|
        unless Para.components.section_for(section.identifier)
          section.destroy
        end
      end
    end

    private

    def components
      Para::Component::Base.all.to_a
    rescue ActiveRecord::SubclassNotFound => e
      # When a subclass is not found, define it and try loading all components.
      #
      # Since we're probably about to destroy this class, this sould not
      # produce errors for the end user
      #
      if (match = e.message.match(/the subclass: '([\w:]+)'/))
        define_temporary_component_subclass(match[1])
        return components
      end

      raise e
    end

    def define_temporary_component_subclass(subclass_name)
      subclass_path = subclass_name.split('::')

      subclass_path.each_with_index.each_with_object([]) do |(const_name, index), path|
        parent_name = path.join('::').presence

        begin
          [parent_name, const_name].compact.join('::').constantize
        rescue NameError
          # Last iterated constnat is the actual component subclass, others must
          # be modules namespacing the component class
          object = if index == (subclass_path.length - 1)
            Class.new(Para::Component::Base)
          else
            Module.new
          end

          parent = parent_name ? parent_name.constantize : Object
          # Define module or class in parent namespace
          parent.const_set(const_name, object)
        end

        # Add const name to the path to allow namespaced constants to be
        # defined in next loop iteration
        path << const_name
      end
    end
  end
end
