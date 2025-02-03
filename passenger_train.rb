class PassengerTrain < Train
  TRAIN_TYPE = :passenger

  def initialize(number)
    super(number, TRAIN_TYPE)
  end

  def carriage_add
    return length if speed > 0

    @length += 1
  end
end