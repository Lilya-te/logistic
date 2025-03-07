class CargoCarriage < Carriage
  attr_reader :filled_volume

  def initialize(volume)
    super(CargoTrain::TRAIN_TYPE, volume.to_f)
  end

  def volume
    self.capacity
  end

  def free_volume
    self.free_capacity
  end

  def show_info
    super('volume')
  end
end