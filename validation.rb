# frozen_string_literal: true

module Validation
  def self.valid?
    validate!
    true
  rescue StandardError
    false
  end
end
