# frozen_string_literal: true

class CargoCarriage < Carriage
  attr_reader :filled_volume

  def initialize(volume)
    super(CargoTrain::TRAIN_TYPE, volume.to_f)
  end

  def volume
    capacity
  end

  def free_volume
    free_capacity
  end

  def show_info
    super('volume')
  end
end
