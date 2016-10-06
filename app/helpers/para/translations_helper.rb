module Para
  module TranslationsHelper
    # This helper method allows to use ActiveModel or ActiveRecord model
    # hierarchy to use translations with automatic defaults from parent models.
    #
    # This works by scanning all the model ancestors to find an existing
    # translation, allowing defining parent class translations and optionnaly
    # overriding translations in subclasses scope
    #
    def model_translate(key, model: nil, scope: nil, **options)
      # Get model class if model argument was passed a model instance
      model = model.class if model.class.respond_to?(:model_name)

      # Create a key for every parent class that could contain a translation
      defaults = model.lookup_ancestors.map do |klass|
        :"#{ scope }.#{ klass.model_name.i18n_key }.#{ key }"
      end

      defaults << options.delete(:default) if options[:default]
      options[:default] = defaults

      I18n.translate(defaults.shift, options)
    end
  end
end
