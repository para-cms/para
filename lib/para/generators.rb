require 'para/generators/name_helpers'

module Para
  module Generators
    extend ActiveSupport::Autoload

    autoload :FieldHelpers
    autoload :NamedBase
    autoload :NameHelpers
  end
end
