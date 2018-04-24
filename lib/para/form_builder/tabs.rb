module Para
  module FormBuilder
    module Tabs
      def tabs(options = {}, &block)
        manager = TabsManager.new(template, object, self, options)
        block.call(manager)
        manager.finalize!

        template.render partial: 'para/form/tabs', locals: { tabs_manager: manager, tabs: manager.tabs }
      end

      class TabsManager
        attr_reader :template, :object, :builder, :options

        def initialize(template, object, builder, options)
          @template = template
          @object = object
          @builder = builder
          @options = options
        end

        def tab(identifier, options = {}, &block)
          tabs << Tab.new(template, object, builder, identifier, options, tabs.length, &block)
          nil
        end

        def tabs
          @tabs ||= []
        end

        def finalize!
          # Set all tabs as inactive if one of the tabs was set to be active
          # manually
          if tabs.any?(&:active)
            active_already_set = false

            tabs.each do |tab|
              # Get a boolean value for the current active state of the tab
              tab_active = !!tab.active

              tab.active = !active_already_set && tab_active

              # Set the "already set" flag to true once we found one active
              # tab, forcing `active = false` for all further tabs
              active_already_set ||= tab_active
            end
          end
        end

        def affix?
          options[:affix]
        end
      end

      class Tab
        attr_reader :template, :object, :builder, :identifier, :icon, :content,
                    :index

        attr_accessor :active

        delegate :capture, to: :template

        def initialize(template, object, builder, identifier, options, index, &content_block)
          @template = template
          @object = object
          @builder = builder
          @identifier = identifier
          @content = capture { content_block.call }
          @icon = options[:icon]
          @active = options[:active]
          @index = index
        end

        def title
          if Symbol === identifier
            ::I18n.t("forms.tabs.#{ object.class.model_name.i18n_key }.#{ identifier }")
          else
            identifier
          end
        end

        def dom_id
          @dom_id = [
            'form-tab',
            builder.nested_resource_dom_id.presence,
            identifier.to_s.parameterize
          ].compact.join('-')
        end

        def active?
          active == true || (active == nil && index == 0)
        end
      end
    end
  end
end
