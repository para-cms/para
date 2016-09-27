module Para
  module Sti
    module RootModel
      extend ActiveSupport::Concern

      included do
        class << self
          def descendants_with_eager_loaded_subclasses
            eager_load!
            descendants_without_eager_loaded_subclasses
          end

          alias_method_chain :descendants, :eager_loaded_subclasses
        end
      end

      module ClassMethods
        def eager_load!
          return if RequestStore.store[descendants_eager_load_key]
          RequestStore.store[descendants_eager_load_key] = true

          models_dir = Rails.root.join('app', 'models')

          Dir[models_dir.join(subclasses_dir, '*.rb')].each do |file_path|
            file_name = File.basename(file_path, '.rb')

            # Avoid Circular dependecy errors in development, when the first
            # loaded class is not the base class. In this case, the base class
            # loading is triggered by the child, so if we try to load that child
            # again, Rails issues a CircularDependency error
            file_load_path = File.join(File.dirname(file_path), file_name)
            next if ActiveSupport::Dependencies.loading.include?(file_load_path)

            # Autoload the subclass
            require file_load_path
          end
        end

        private

        def descendants_eager_load_key
          @descendants_eager_load_key ||= [
            'para', 'root_model', 'descendants_eager_loaded', name
          ].join(':')
        end

        # Allows the including class to define `.subclasses_namespace` class
        # method to override the namespace and directory used to eager load the
        # subclasses.
        #
        # Note : No error is raised if target subclasses directory does not
        #        exist.
        #
        def subclasses_namespace
          @subclasses_namespace ||= name.deconstantize
        end

        def subclasses_dir
          @subclasses_dir ||= subclasses_namespace.underscore
        end
      end
    end
  end
end
