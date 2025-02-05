class PassengerCarriage < Carriage

  def initialize
    super(PassengerTrain::TRAIN_TYPE)
  end
end