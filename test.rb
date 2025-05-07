# frozen_string_literal: true

require_relative 'accessors'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'company'
require_relative 'train'
require_relative 'carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'route'
require_relative 'station'

# puts "Train Accessors strong_attr_accessor speed"
#
# train = Train.new('AAA-11', :cargo)
# puts "SUCCEED train.speed == 0 #{train.speed == 0}"
# puts "SUCCEED train.speed = 1 #{train.speed = 1}"
# train.speed_up
# puts "train.speed_history = #{train.speed_history}"
#
# station_a = Station.new('A')
# station_b = Station.new('B')
# station_c = Station.new('C')
# route_1 = Route.new(station_a, station_b)
# route_2 = Route.new(station_b, station_c)
# train.route = route_1
# train.route = route_2
#
# carriage_1 = CargoCarriage.new(1)
# carriage_2 = CargoCarriage.new(2)
# train.carriage_add carriage_1
# train.carriage_add carriage_2
#
# begin
#   train.type = '!!!!'
# rescue StandardError => e
#   puts "FAILURE Type #{e.message == 'Impossible value. Value type must be Symbol'}"
# end

# Validation
puts "VALIDATION PRECENCE"
begin
  Train.new('AAA-11', :cargo).validate!
rescue => e
  puts "e.message = #{e.message}"
end
# begin
#   Train.new('AA-11', :cargo)
# rescue => e
#   puts "e.message = #{e.message}"
# end
# begin
#   Train.new(['A'], :cargo)
# rescue => e
#   puts "e.message = #{e.message}"
# end