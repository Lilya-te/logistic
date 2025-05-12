# frozen_string_literal: true

module Validation

  def self.valid?
    self.validate!
    true
  rescue StandardError
    false
  end

  #  - presence - требует, чтобы значение атрибута было не nil и не пустой строкой.
  #  - format (при этом отдельным параметром задается регулярное выражение для формата).
  # Треубет соответствия значения атрибута заданному регулярному выражению.
  #  - type (третий параметр - класс атрибута). Требует соответствия значения атрибута заданному классу.
  def validate(attribute_name, validation_type, *args)
    raise(StandardError, 'Undefined validation type.') unless %i[presence format type].include?(validation_type)
    method_name = "#{attribute_name}_#{validation_type}".to_sym

    define_method(method_name) do
      attribute_value = instance_variable_get("@#{attribute_name}")

      case validation_type
      when :presence
        raise(StandardError, "Attribute #{attribute_name} value must not be nil or empty.") if attribute_value.to_s.strip.empty?

      when :format
        puts "format"

        format_regexp = args[0]
        raise(StandardError, "Attribute #{attribute_name} value must be #{format_regexp} format.") unless format_regexp.match? attribute_value

      when :type
        attribute_class = args[0]
        raise(StandardError, "Attribute #{attribute_name} value must be #{attribute_class}.") unless attribute_value.is_a?(attribute_class)

      end
    end

    @@validations ||= []
    @@validations << method_name

    define_method(:validate!) do
      @@validations.each do |validate|
        eval "self.#{validate}"
      end
    end
  end
end
