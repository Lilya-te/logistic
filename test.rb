load 'route.rb'
load 'station.rb'
load 'train.rb'

# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
msk = Station.new('Moscow')
spb = Station.new('Saint-Peterburg')
ekb = Station.new('Ekaterinburg')
kzn = Station.new('Kazan')
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
route = Route.new(spb, msk)
# Может добавлять промежуточную станцию в список
route.add_station(ekb, spb)
route.add_station(kzn, spb)
puts route.print
# Может удалять промежуточную станцию из списка
route.drop_station(ekb)
# Может выводить список всех станций по-порядку от начальной до конечной
puts route.print
route.add_station(ekb, spb)
puts route.print

# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
# эти данные указываются при создании экземпляра класса
pass_train = Train.new('P1', :pass, 1)
cargo_train = Train.new('C1', :cargo, 1)

# Может набирать скорость
puts "Pass train #{pass_train.number}. Speed: #{pass_train.speed}. Length: #{pass_train.length}"
pass_train.speed_up
puts "Pass train #{pass_train.number}. Speed: #{pass_train.speed}. Length: #{pass_train.length}"
cargo_train.speed_up
puts "Pass train #{cargo_train.number}. Speed: #{cargo_train.speed}. Length: #{cargo_train.length}"
cargo_train.speed_up
puts "Up cargo speed train #{cargo_train.number}. Speed: #{cargo_train.speed}"
cargo_train.speed_up
# Может возвращать текущую скорость
puts "Up cargo speed train #{cargo_train.number}. Speed: #{cargo_train.speed}"

# Может тормозить (сбрасывать скорость до нуля)
pass_train.speed_down
cargo_train.extreme_stop
puts "Stop all trains! #{cargo_train.speed} #{pass_train.speed}"

# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
# метод просто увеличивает или уменьшает количество вагонов).
# Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
cargo_train.car_add
cargo_train.car_add
puts "Pass train #{cargo_train.number}. Length: #{cargo_train.length} must be 3"
cargo_train.speed_up
cargo_train.car_add
puts "Pass train #{cargo_train.number}. Length: #{cargo_train.length} must be 3"

# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад,
# но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
cargo_train.route = route
pass_train.route = route
puts "Pass train #{cargo_train.number}. Station: #{cargo_train.station} must be #{route.start}"
puts "Pass train #{pass_train.number}. Station: #{pass_train.station} must be #{route.start}"

cargo_train.move_forward
cargo_train.move_forward
puts "Pass train #{cargo_train.number}. Station: #{cargo_train.station} must be Kazan"
cargo_train.move_back
puts "Pass train #{cargo_train.number}. Station: #{cargo_train.station} must be Ekaterinburg"

pass_train.move_forward
puts "Pass train #{pass_train.number}. Station: #{pass_train.station} must be Ekaterinburg"

# Класс Station (Станция):
# Может принимать поезда (по одному за раз)
ekb.accept_train(pass_train)
ekb.accept_train(cargo_train)

# Может возвращать список всех поездов на станции, находящиеся в текущий момент
puts "#{spb.name}. Trains: #{spb.all_trains}"
puts "#{kzn.name}. Trains: #{kzn.all_trains}"
puts "#{msk.name}. Trains: #{msk.all_trains}"

# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
puts "#{ekb.name}. Pass trains: #{ekb.all_trains(type: :pass)}"
puts "#{ekb.name}. Cargo trains: #{ekb.all_trains(type: :cargo)}"
puts "#{ekb.name}. All trains: #{ekb.all_trains}"

# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
ekb.send_train(pass_train)
ekb.send_train(cargo_train)
puts "#{ekb.name}. All trains: #{ekb.all_trains}"
