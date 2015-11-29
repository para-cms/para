module Para
  module FormBuilder
    module Tabs
      def tabs(&block)
        tabs = TabsManager.new(template, object)
        block.call(tabs)

        template.content_tag(:div, class: 'form-tabs') do
          tabs.navigation + tabs.panels
        end
      end

      class TabsManager
        attr_reader :template, :object

        delegate :content_tag, to: :template

        def initialize(template, object)
          @template = template
          @object = object
        end

        def tab(identifier, options = {}, &block)
          tab = Tab.new(template, object, identifier, options)
          tab.fill_with(&block)
          tabs << tab

          nil
        end

        def tabs
          @tabs ||= []
        end

        def navigation
          content_tag(:nav, class: 'navbar navbar-inverse') do
            content_tag(:ul, class: 'nav navbar-nav', role: 'tablist') do
              tabs.each_with_index.map do |tab, index|
                tab.render_tab(active: (index == 0))
              end.join.html_safe
            end
          end
        end

        def panels
          content_tag(:div, class: 'tab-content') do
            tabs.each_with_index.map do |tab, index|
              tab.render_panel(active: (index == 0))
            end.join.html_safe
          end
        end
      end

      class Tab
        attr_reader :template, :object, :identifier, :icon, :content

        delegate :content_tag, :capture, :link_to, to: :template

        def initialize(template, object, identifier, options)
          @template = template
          @object = object
          @identifier = identifier

          if (icon_name = options[:icon])
            @icon = content_tag(:i, '', class: "fa fa-#{ icon_name }")
          end
        end

        def title
          if Symbol === identifier
            I18n.t("forms.tabs.#{ object.class.model_name.i18n_key }.#{ identifier }")
          else
            identifier
          end
        end

        def fill_with(&block)
          @content = capture { block.call }
        end

        def render_tab(active: false)
          link_options = { role: 'tab', aria: { controls: 'settings' }, data: { toggle: 'tab' } }

          content_tag(:li, class: ('active' if active), role: 'presentation') do
            link_to("##{ dom_id }", link_options) do
              [icon, title].compact.join('&nbsp;').html_safe
            end
          end
        end

        def render_panel(active: false)
          content_tag(:div, id: dom_id, class: "tab-pane #{ 'active' if active }", role: 'tabpanel') do
            content
          end
        end

        def dom_id
          @dom_id = identifier.to_s.parameterize
        end
      end
    end
  end
end
