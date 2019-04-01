module Para
  module Cloneable
    class IncludeTreeBuilder
      attr_reader :resource,  :cloneable_options

      def initialize(resource, cloneable_options)
        @resource = resource
        @cloneable_options = cloneable_options.deep_dup
      end
      
      def build
        include_tree = build_cloneable_tree(resource, cloneable_options[:include])
        cloneable_options[:include] = clean_include_tree(include_tree)
        cloneable_options
      end
      
      private

      def build_cloneable_tree(resource, include)
        include.each_with_object({}) do |reflection_name, hash|
          hash[reflection_name] = {}

          if (reflection = resource.class.reflections[reflection_name.to_s])
            reflection_options = hash[reflection_name]
            association_target = resource.send(reflection_name)
            
            if reflection.collection?
              association_target.each do |nested_resource|
                add_reflection_options(reflection_options, nested_resource)
              end
            else
              add_reflection_options(reflection_options, association_target)
            end
          end      
        end
      end

      def add_reflection_options(reflection_options, nested_resource)
        options = nested_resource.class.try(:cloneable_options)
        return reflection_options unless options
        
        include_options = options[:include]
        target_options = build_cloneable_tree(nested_resource, include_options)
        reflection_options.deep_merge!(target_options)
      end

      def clean_include_tree(tree)
        shallow_relations = []
        deep_relations = {}
        
        tree.each do |key, value|
          if !value || value.empty?
            shallow_relations << key
          else
            deep_relations[key] = clean_include_tree(value)
          end
        end

        if deep_relations.empty?
          shallow_relations
        else
          shallow_relations + [deep_relations]
        end
      end
    end
  end
end