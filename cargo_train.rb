class CargoTrain < Train
  TRAIN_TYPE = :cargo

  def initialize(number)
    super(number, TRAIN_TYPE)
  end
end