module Para
  module Generators
    module NameHelpers
      def plural_namespaced_path
        @plural_namespaced_path ||= File.join(*class_path, plural_name)
      end

      def singular_namespaced_path
        @singular_namespaced_path ||= File.join(*class_path, singular_name)
      end
    end
  end
end
