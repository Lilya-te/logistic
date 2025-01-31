# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
class Route
  attr_reader :start, :stations

  def initialize(start, finish)
    @start = start.name
    @finish = finish.name
    @stations = {start.name => finish.name}
  end

  def add_station(station, prev_station)
    point = @stations[prev_station.name]
    @stations[prev_station.name] = station.name
    @stations[station.name] = point
  end

  def drop_station(station)
    point = @stations.delete(station.name)
    @stations.each{|k,v| @stations[k] = point if v == station.name}
  end

  def print
    point = @start
    result = []
    until @stations[point].nil?
      result << point
      point = @stations[point]
      puts("result = #{result}")
    end

    (result << point).map{|s| s}.join(' >>> ')
  end
end