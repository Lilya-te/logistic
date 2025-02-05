# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
class Route
  attr_accessor :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def start_station
    stations.first
  end

  def finish_station
    stations.last
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def drop_station(station)
    stations.delete(station)
  end

  def show
    stations.map { |station| station.name }
  end
end