module Para
  module FormBuilder
    module Tabs
      def tabs(&block)
        tabs_manager = TabsManager.new(template, object)
        block.call(tabs_manager)

        template.render partial: 'para/form/tabs', locals: { tabs: tabs_manager.tabs }
      end

      class TabsManager
        attr_reader :template, :object

        def initialize(template, object)
          @template = template
          @object = object
        end

        def tab(identifier, options = {}, &block)
          tabs << Tab.new(template, object, identifier, options, &block)
          nil
        end

        def tabs
          @tabs ||= []
        end
      end

      class Tab
        attr_reader :template, :object, :identifier, :icon, :content

        delegate :capture, to: :template

        def initialize(template, object, identifier, options, &content_block)
          @template = template
          @object = object
          @identifier = identifier
          @content = capture { content_block.call }
          @icon = options[:icon]
        end

        def title
          if Symbol === identifier
            I18n.t("forms.tabs.#{ object.class.model_name.i18n_key }.#{ identifier }")
          else
            identifier
          end
        end

        def dom_id
          @dom_id = identifier.to_s.parameterize
        end
      end
    end
  end
end
