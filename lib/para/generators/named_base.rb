module Para
  module Generators
    class NamedBase < Rails::Generators::NamedBase
      include Para::Generators::NameHelpers
    end
  end
end
