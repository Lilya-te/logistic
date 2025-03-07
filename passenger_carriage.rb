class PassengerCarriage < Carriage
  attr_reader :tickets

  def initialize(seats)
    super(PassengerTrain::TRAIN_TYPE, seats.to_i)
  end

  def seats
    self.capacity
  end

  def buy_ticket
    self.upload(1)
  end

  def free_seats
    self.free_capacity
  end

  def show_info
    super('seats')
  end
end