class Carriage
  include Company

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private
  
  def validate!
    nil
  end
end