module Para
  module Sti
    module RootModel
      extend ActiveSupport::Concern

      module ClassMethods
        def eager_load!
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
