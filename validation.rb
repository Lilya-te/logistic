module Validation
  def self.valid?
    validate!
    true
  rescue StandardError
    false
  end
end