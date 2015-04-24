module Para
  module Generators
    module NameHelpers
      def plural_namespaced_path
        @plural_namespaced_path ||= File.join(*class_path, plural_name)
      end
    end
  end
end
