module Para
  module Ext
    module SimpleFormExtension
      module SelectizeInput
        extend ActiveSupport::Concern

        included do
          alias_method_chain :name_for, :admin_name
        end

        def name_for_with_admin_name(option)
          Para.config.resource_name_methods.each do |method|
            if (name = option.try(method))
              return name
            end
          end
        end
      end
    end
  end
end
