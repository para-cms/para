# This extension is needed because of Para's params input parsing which creates
# empty placeholder records for nested attributes before their params are
# assigned.
#
# This patch hooks into Rails nested attributes logic to clean all placeholder
# data during the params assignation process.
#
module Para
  module Ext
    module ActiveRecord
      module NestedAttributes
        # Handle rejected nested records that have a fake id, which means that
        # the resource was nevertheless created by Para during input params
        # parsing. Therefore, we clean those records when they're rejected.
        #
        def call_reject_if(association_name, attributes)
          super.tap do |rejected|
            if rejected && attributes['id'].to_s.match(/\A__/)
              records = association(association_name).target

              if ::ActiveRecord::Base === records
                records.destroy
              elsif (record = records.find { |res| res.id == attributes['id'] })
                records.delete(record)
              end
            end
          end
        end
      end

      module NestedAttributesClassMethods
        # Override default :reject_all proc to handle fake ids as empty keys,
        # avoiding the model to be created with only its fake id.
        PARA_REJECT_ALL_BLANK_PROC = proc { |attributes|
          attributes.all? { |key, value|
            (key == 'id' && value.to_s.match(/\A__/)) || key == '_destroy' || value.blank?
          }
        }

        # Intercept the `reject_if: :all_blank` option to also consider fake
        # ids as blank fields and avoid empty params assignation
        #
        def accepts_nested_attributes_for(*attr_names)
          options = attr_names.extract_options!
          options[:reject_if] = PARA_REJECT_ALL_BLANK_PROC if options[:reject_if] == :all_blank
          super(*attr_names, options)
        end
      end
    end
  end
end
