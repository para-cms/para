module Para
  module ModelFieldParsers
    def self.registered_parsers
      @registered_parsers ||= {}
    end

    def self.parse!(model, fields_hash)
      registered_parsers.each do |_, parser_class|
        parser = parser_class.new(model, fields_hash)
        parser.parse! if parser.applicable?
      end
    end
  end
end

require 'para/model_field_parsers/base'
require 'para/model_field_parsers/devise'
require 'para/model_field_parsers/paperclip'
require 'para/model_field_parsers/orderable'
require 'para/model_field_parsers/relations'
require 'para/model_field_parsers/redactor'
require 'para/model_field_parsers/globalize'
require 'para/model_field_parsers/store'
require 'para/model_field_parsers/enums'
