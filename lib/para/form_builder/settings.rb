module Para
  module FormBuilder
    module Settings
      def settings_input(name, options = {}, &block)
        options.reverse_merge!(as: :setting)

        setting = ::Settings.get(name, options[:type])

        input(name, options) do
          fields_for(:settings, setting) do |fields|
            fields.hidden_field(:key) +
            fields.hidden_field(:_type) +

            if block
              block.call(fields)
            else
              fields.text_field(:value, class: 'form-control')
            end
          end
        end
      end
    end
  end
end
