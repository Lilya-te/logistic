# frozen_string_literal: true

# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
class Route
  include InstanceCounter
  include Validation

  attr_accessor :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
    register_instance
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
    stations.map(&:name)
  end

  def name
    "#{stations[0].name} -> #{stations[-1].name}"
  end

  private

  def validate!
    raise StandardError, 'Invalid stations.' unless stations.any? { |station| station.is_a?(Station) }
  end
end
