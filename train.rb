# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
# эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
# метод просто увеличивает или уменьшает количество вагонов).
# Прицепка/отцепка вагонов может осуществляться только если поезд не движется.

# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад,
# но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

class Train
  include Company
  include InstanceCounter

  attr_reader :speed, :number, :type
  attr_accessor :route
  attr_writer :carriages
  @@trains = []

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @@trains << self
    self.register_instance
  end

  def self.find(number)
    @@trains.find {|train| train.number == number }
  end

  def route=(route)
    @route = route
    @station_inx = 0
  end

  def next_station
    route.stations[@station_inx + 1]
  end

  def current_station
    route.stations[@station_inx]
  end

  def previous_station
    route.stations[@station_inx - 1]
  end

  def go_next_station
    @station_inx += 1 if next_station
  end

  def go_previous_station
    @station_inx -= 1 if previous_station
  end

  def speed_up
    @speed += 1
  end

  def speed_down
    if @speed == 0
      return 0
    else
      @speed -= 1
    end
  end

  def extreme_stop
    @speed = 0
  end

  def carriage_add(carriage)
    @carriages << carriage if type == carriage.type
  end

  def carriage_remove
    @carriages.delete_at(-1)
  end
end