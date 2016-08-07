module Para
  module Admin
    module DecoratorsHelper
      def decorated(object)
        object.tap(&method(:decorate))
      end

      def decorate(object)
        ActiveDecorator::Decorator.instance.decorate(object)
      end
    end
  end
end
