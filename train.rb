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
  attr_reader :speed, :length, :station, :number, :type
  attr_accessor :route

  def initialize(number, type, length)
    @number = number
    @type = type
    @length = length
    @speed = 0
    @route = nil
    @station = nil
  end

  def route=(route)
    @route = route
    @station = route.start
  end

  def move_forward
    @station = next_station
  end

  def move_back
    @station = prev_station
  end

  def prev_station
    @route.stations.each do |k,v|
      return k if v == @station
    end
  end

  def next_station
    @route.stations[@station]
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

  def car_add
    return @length if @speed > 0

    @length += 1
  end

  def car_remove
    return @length if @speed > 0

    if @length == 0
      return 0
    else
      @length -= 1
    end
  end
end