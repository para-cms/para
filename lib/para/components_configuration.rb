module Para
  class ComponentsConfiguration
    class UndefinedComponentTypeError < StandardError
    end

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

    def section_for(identifier)
      if (section = sections_cache[identifier])
        section
      elsif (section_id = sections_ids_hash[identifier])
        sections_cache[identifier] = Para::ComponentSection.find(section_id)
      end
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
        sections_ids_hash[section.identifier] = section.model.id

        section.components.each do |component|
          components_ids_hash[component.identifier] = component.model.id
        end
      end
    end

    def sections_ids_hash
      @sections_ids_hash ||= {}.with_indifferent_access
    end

    def components_ids_hash
      @components_ids_hash ||= {}.with_indifferent_access
    end

    # Only store sections cache for the request duration to avoid expired
    # references to AR objects between requests
    #
    def sections_cache
      RequestStore.store[:sections_cache] ||= {}.with_indifferent_access
    end

    # Only store components cache for the request duration to avoid expired
    # references to AR objects between requests
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
    rescue ActiveRecord::NoDatabaseError
      false # Do not load components when the database is not installed
    end

    # Eager loads every file ending with _component.rb that's included in a
    # $LOAD_PATH directory which ends in "/components"
    #
    # Note : This allows not to process too many folders, but makes it harder to
    # plug gems into the components system
    #
    def eager_load_components!
      $LOAD_PATH.each do |path|
        next unless path.match(/\/components$/)

        glob = File.join(path, '**', '*_component.rb')

        Dir[glob].each do |file|
          load(file)
        end
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

      def initialize(identifier, type_identifier, options = {})
        self.identifier = identifier.to_s
        self.type = Para::Component.registered_components[type_identifier]
        self.options = options

        unless type
          raise UndefinedComponentTypeError.new(
            "Undefined Para component : #{ type_identifier }. " +
            "Please ensure that your app or gems define this component type."
          )
        end
      end

      def refresh(attributes = {})
        self.model = type.where(identifier: identifier).first_or_initialize
        model.update_with(attributes.merge(options_with_defaults))
        model.save!
      end

      # Ensures unset :configuration store options are set to nil to allow
      # removing a configuration option from the components.rb file
      #
      def options_with_defaults
        configurable_keys = type.local_stored_attributes.try(:[], :configuration) || []
        configurable_keys += options.keys
        configurable_keys.uniq!

        configurable_keys.each_with_object({}) do |key, hash|
          hash[key] = options[key]
        end
      end
    end
  end
end
