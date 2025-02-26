# Класс Station (Станция):
#   Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    self.register_instance
  end

  def trains_by_type(type)
    trains.select {|train| train.type == type}.count
  end

  def accept_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def self.all
    @@stations
  end

  private
  
  def validate!
    raise StandardError, 'Invalid station name!' if (name !~ /^[\w-]{1,}$/)
  end
end