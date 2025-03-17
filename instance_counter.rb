# frozen_string_literal: true

module InstanceCounter
  @@instances = 0

  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  def self.instances
    @@instances
  end

  def self.register_instance
    @@instances += 1
  end

  module ClassMethods
    def instances
      InstanceCounter.instances
    end
  end

  module InstanceMethods
    protected

    def register_instance
      InstanceCounter.register_instance
    end
  end
end
