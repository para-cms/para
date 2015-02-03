module Para
  class ComponentsConfiguration
    def draw(&block)
      load_components
      instance_eval(&block)
      build
    end

    def section(*args, &block)
      sections << Section.new(*args, &block)
    end

    def sections
      @sections ||= []
    end

    private

    def build
      sections.each_with_index do |section, index|
        section.refresh(position: index)
      end
    end

    def load_components
      glob = Rails.root.join('app', 'components', '**', '*_component.rb')

      Dir[glob].each do |file|
        load(file)
      end
    end

    class Section
      attr_accessor :identifier

      def initialize(identifier, &block)
        self.identifier = identifier.to_s
        instance_eval(&block)
      end

      def component(*args)
        components << Component.new(*args)
      end

      def components
        @components ||= []
      end

      def refresh(attributes = {})
        section = ComponentSection.where(identifier: identifier).first_or_initialize
        section.assign_attributes(attributes)
        section.save!

        components.each_with_index do |component, index|
          component.refresh(component_section: section, position: index)
        end
      end
    end

    class Component
      attr_accessor :identifier, :type, :options

      def initialize(identifier, type, options = {})
        self.identifier = identifier.to_s
        self.type = Para::Component.registered_components[type]
        self.options = options
      end

      def refresh(attributes = {})
        component = type.where(identifier: identifier).first_or_initialize
        component.assign_attributes(attributes.merge(options))
        component.save!
      end
    end
  end
end
