class Carriage
  include Company
  include Validation

  attr_reader :type, :capacity, :filled_capacity

  def initialize(type, capacity)
    @type = type
    @capacity = capacity
    @filled_capacity = 0
    validate!
  end

  def upload(units)
    raise StandardError, "Not enough space" if free_capacity < units
    @filled_capacity += units
  end

  def free_capacity
    capacity - filled_capacity
  end

  private

  def validate!
    raise StandardError, 'Invalid type.' if type.nil?
  end
end