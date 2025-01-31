# Класс Station (Станция):
#   Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = {pass: [], cargo: []}
  end

  def all_trains(type: nil)
    all_trains = type.nil? ? (@trains[:pass] + @trains[:cargo]) : @trains[type]
    all_trains.map{|train| train.number}.to_s unless all_trains.nil?
  end

  def accept_train(train)
    (@trains[train.type] << train unless @trains[train.type].include?(train)) if train.station

    train
  end

  def send_train(train)
    @trains[train.type].delete(train) if train.station

    train
  end
end