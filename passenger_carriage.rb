# frozen_string_literal: true

class PassengerCarriage < Carriage
  attr_reader :tickets

  def initialize(seats)
    super(PassengerTrain::TRAIN_TYPE, seats.to_i)
  end

  def seats
    capacity
  end

  def buy_ticket
    upload(1)
  end

  def free_seats
    free_capacity
  end

  def show_info
    super('seats')
  end
end
