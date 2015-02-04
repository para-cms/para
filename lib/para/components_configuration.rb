module Para
  class ComponentsConfiguration
    def draw(&block)
      return unless components_installed?
      eager_load_components!
      instance_eval(&block)
      build
    end

    def section(*args, &block)
      sections << Section.new(*args, &block)
    end

    def sections
      @sections ||= []
    end

    def method_missing(method, *args, &block)
      component_for(method) || super
    end

    def component_for(identifier)
      if (component = components_cache[identifier])
        component
      elsif (component_id = components_ids_hash[identifier])
        components_cache[identifier] = Para::Component::Base.find(component_id)
      end
    end

    private

    def build
      sections.each_with_index do |section, index|
        section.refresh(position: index)

        section.components.each do |component|
          components_ids_hash[component.identifier] = component.model.id
        end
      end
    end

    def components_ids_hash
      @components_ids_hash ||= {}.with_indifferent_access
    end

    # Only store components cache for the request duration to avoid expired
    # references to AR object between requests
    #
    def components_cache
      RequestStore.store[:components_cache] ||= {}.with_indifferent_access
    end

    def components_installed?
      tables_exist = %w(component/base component_section).all? do |name|
        Para.const_get(name.camelize).table_exists?
      end

      unless tables_exist
        Rails.logger.warn(
          "Para migrations are not installed.\n" \
          "Skipping components definition until next app reload."
        )
      end

      tables_exist
    end

    def eager_load_components!
      glob = Rails.root.join('app', 'components', '**', '*_component.rb')

      Dir[glob].each do |file|
        load(file)
      end
    end

    class Section
      attr_accessor :identifier, :model

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
        self.model = ComponentSection.where(identifier: identifier).first_or_initialize
        model.assign_attributes(attributes)
        model.save!

        components.each_with_index do |component, index|
          component.refresh(component_section: model, position: index)
        end
      end
    end

    class Component
      attr_accessor :identifier, :type, :options, :model

      def initialize(identifier, type, options = {})
        self.identifier = identifier.to_s
        self.type = Para::Component.registered_components[type]
        self.options = options
      end

      def refresh(attributes = {})
        self.model = type.where(identifier: identifier).first_or_initialize
        model.assign_attributes(attributes.merge(options))
        model.save!
      end
    end
  end
end
