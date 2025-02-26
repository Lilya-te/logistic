class Carriage
  include Company
  include Validation

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  private

  def validate!
    raise StandardError, 'Invalid type.' if type.nil?
  end
end