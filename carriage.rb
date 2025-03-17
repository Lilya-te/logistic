# frozen_string_literal: true

class Carriage
  include Company
  include Validation

  attr_reader :type, :capacity, :filled_capacity

  def initialize(type, capacity)
    @type = type
    @capacity = capacity
    @filled_capacity ||= 0
    validate!
  end

  def upload(units)
    raise StandardError, 'Not enough space' if free_capacity < units

    @filled_capacity += units
  end

  def free_capacity
    capacity - filled_capacity
  end

  def show_info(unit_name)
    "Type: #{type.capitalize}. " \
    "#{unit_name.capitalize}: #{capacity}, free #{unit_name}: #{free_capacity}"
  end

  private

  def validate!
    raise StandardError, 'Invalid type.' if type.nil?
  end
end
