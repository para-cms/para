module Para
  module Cloneable
    extend ActiveSupport::Concern

    included do
      class_attribute :cloneable_options
    end

    # Wraps the deep_cloneable gem #deep_clone method to allow using the
    # predefined associations and options from our Cloneable.acts_as_cloneable
    # macro.
    #
    def deep_clone!(options = {})
      options = options.reverse_merge(cloneable_options)
      callback = build_clone_callback(options.delete(:prepare))

      deep_clone(options, &callback)
    end

    private

    # We ensure that the passed callback is actually callable on the object
    # we're cloning. This is needed for associations because deep_cloneable
    # calls the callback for every associated object.
    #
    def build_clone_callback(callback)
      case callback
      when Proc
        callback
      when Symbol
        ->(original, clone) {
          original.send(callback, clone) if original.respond_to?(callback, true)
        }
      end
    end

    module ClassMethods
      # Allow configuring cloneable options for the model, and making the
      # model cloneable in the admin
      #
      # The provided arguments are the cloneable associations for the model,
      # and keyword arguments are passed to the #deep_clone method.
      #
      # An optional :prepare keyword argument can be passed and will be called
      # by #deep_clone to allow altering the cloned resource before saving it.
      #
      def acts_as_cloneable(*args)
        @cloneable = true

        options = args.extract_options!

        self.cloneable_options = options.reverse_merge({
          include: args
        })
      end

      def cloneable?
        @cloneable ||= false
      end
    end
  end
end
