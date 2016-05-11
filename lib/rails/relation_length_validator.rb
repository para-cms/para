class RelationLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if smaller?(value)
      record.errors.add(attribute, smaller_error_message, options)
    elsif greater?(value)
      record.errors.add(attribute, greater_error_message, options)
    end
  end

  private

  def minimum
    options[:minimum] || 0
  end

  def maximum
    options[:maximum] || Float::INFINITY
  end

  def smaller?(value)
    value.length < minimum
  end

  def greater?(value)
    value.length > minimum
  end

  def smaller_error_message
    message = options[:message] && options[:message][:minimum]
    message || ::I18n.t(
      "activerecord.errors.relation_length_is_smaller",
      minimum: minimum,
      default: "must have at least #{ minimum } elements"
    )
  end

  def greater_error_message
    message = options[:message] && options[:message][:maximum]
    message || ::I18n.t(
      "activerecord.errors.relation_length_is_greater",
      maximum: maximum,
      default: "must have at most #{ maximum } elements"
    )
  end
end
