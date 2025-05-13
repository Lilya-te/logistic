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

class Logistic
  MENU = [{ id: 1, title: 'create station', action: :create_station, description: 'create new station' },
          { id: 2, title: 'create train', action: :create_train, description: 'create passenger or cargo train' },
          { id: 3, title: 'create route', action: :create_route, description: 'create new route' },
          { id: 4, title: 'add route station', action: :add_route_station,
            description: 'add existed or new station to the route' },
          { id: 5, title: 'remove route station', action: :remove_route_station,
            description: 'remove station from route' },
          { id: 6, title: 'assign route for train', action: :assign_route_for_train,
            description: 'assign existed route for existed train' },
          { id: 7, title: 'add carriage to train', action: :add_carriage_to_train,
            description: 'add carriage to train' },
          { id: 8, title: 'remove carriage from train', action: :remove_carriage_from_train,
            description: 'remove carriage from train' },
          { id: 9, title: 'upload cargo carriage or buy ticket to passenger train', action: :upload_train,
            description: 'upload cargo carriage' },
          { id: 10, title: 'move train to the next station', action: :move_train_to_the_next_station,
            description: 'move train to the next route station' },
          { id: 11, title: 'move train to the previous station', action: :move_train_to_the_previous_station,
            description: 'move train to the previous route station' },
          { id: 12, title: 'show stations list', action: :show_stations_list, description: 'show stations list' },
          { id: 13, title: 'show trains list for the station', action: :show_trains_list_for_the_station,
            description: 'show trains list for the station' },
          { id: 14, title: 'show train carriages', action: :train_carriages, description: 'show train carriages list' },
          { id: 15, title: 'exit', action: :stop, description: 'exit' },
          { id: 16, title: 'show commands', action: :help, description: 'show commands' }].freeze

  def initialize
    @stations_array = []
    @trains_array = []
    @routes_array = []
    @break = false
  end

  def start
    welcome_text
    help

    loop do
      @command = nil
      ask_action
      do_action if @command
      break if @break
    end
  end

  private

  def welcome_text
    puts 'Welcome to HAPPY LOGISTIC INTERFACE'
    puts "Input 'help' to show commands!"
  end

  def ask_action
    puts 'Input command number, please.'
    command_index = gets.chomp
    @command = MENU.find { |item| item[:id] == command_index.to_i }
    puts "Command #{command_index} NOT FOUND! Input 'help' to view full command list." unless @command
  end

  def do_action
    send @command[:action]
  end

  def stop
    puts 'Thanks fot your attention!'
    @break = true
  end

  def help
    MENU.each do |item|
      printf "%-2<id>s %-50<action>s %<description>s\n",
             { id: item[:id], action: item[:action], description: item[:description] }
    end
  end

  def create_new_station
    name = gets.chomp 
    new_station = Station.new(name)
    @stations_array << new_station

    new_station
  rescue StandardError => e
    failure_message(e.message)
    retry
  end

  def choose_route
    unless @routes_array.empty?
      puts 'Choose the route:'
      @routes_array.each do |r|
        puts "#{r.show} - this one? (y/n)"
        return r if gets.chomp == 'y'
      end
    end
    puts 'There is no route!'
  end

  def choose_train(type = nil)
    trains = type.nil? ? @trains_array : @trains_array.select { |train| train.type == type }
    unless trains.empty?
      puts 'Choose the train:'
      trains.each do |t|
        puts "#{t.type} train number #{t.number} - this one? (y/n)"
        return t if gets.chomp == 'y'
      end
    end
    puts 'There is no more train!'
  end

  def choose_type
    puts 'Train type: passenger or cargo'
    gets.chomp.to_sym
  end

  def succeed_message(text)
    puts "#{text} successfully created"
  end

  def failure_message(text)
    puts "ERROR! #{text}\n===Try again===\n***************"
  end

  def create_station
    puts 'Station name:'
    name = create_new_station
    succeed_message "Station #{name}"
  end

  def create_train
    type = choose_type

    puts 'Train number:'
    number = gets.chomp
    @trains_array << Train.new(number, type)

    succeed_message "#{type} train №'#{number}'"
  rescue StandardError => e
    failure_message(e.message)
    retry
  end

  def find_or_create_station(name)
    @stations_array.find { |s| s.name == name } || create_new_station
  end

  def create_route
    puts 'Route start station name:'
    start_station = find_or_create_station(gets.chomp)

    puts 'Route finish station name:'
    finish_station = find_or_create_station(gets.chomp)

    @routes_array << Route.new(start_station, finish_station)

    succeed_message "Route from '#{start_station.name}' to '#{finish_station.name}'"
  rescue StandardError => e
    failure_message(e.message)
    retry
  end

  # add route station
  def add_route_station
    current_route = choose_route
    return if current_route.nil?

    if current_route.nil?
      puts 'Route not found'
    else
      puts "Chose station name from #{@stations_array.map(&:name)} or input new one."
      station_name = gets.chomp
      current_route.add_station(@stations_array.find { |s| s.name == station_name } || create_new_station)
      puts "Station add to route #{current_route.show}"
    end
  end

  def remove_route_station
    current_route = choose_route
    return if current_route.nil?

    current_route.stations.each do |station|
      puts "Do you want to delete #{station.name}? (y/n)"
      current_route.drop_station(station) if gets.chomp == 'y'
    end
  end

  def assign_route_for_train
    current_route = choose_route
    return if current_route.nil?

    current_train = choose_train
    return if current_train.nil?

    current_train.route = current_route
    current_train.current_station.accept_train(current_train)

    puts "Train #{current_train.number} is on the route #{current_route.show}"
  end

  def train_carriages
    current_train = choose_train
    n = 0
    current_train.carriages_block { |carriage| puts "Number: #{n += 1}, #{carriage.show_info}" }
  end

  def add_carriage_to_train
    current_train = choose_train
    return if current_train.nil?

    puts 'Input volume or seats:'
    current_carriage = if current_train.type == CargoTrain::TRAIN_TYPE
                         CargoCarriage.new(gets.chomp)
                       else
                         PassengerCarriage.new(gets.chomp)
                       end

    current_train.carriage_add(current_carriage)
    succeed_message("Carriage for train №#{current_train.number}")
  end

  def remove_carriage_from_train
    current_train = choose_train
    return if current_train.nil?

    current_train.carriage_remove
    puts "Carriage for train №#{current_train.number} removed"
  end

  def move_train_to_the_next_station
    current_train = choose_train
    return if current_train.nil?

    current_train.current_station.send_train(current_train)
    current_train.go_next_station
    current_train.current_station.accept_train(current_train)

    puts "Train №#{current_train.number} is moving forward."
  end

  def move_train_to_the_previous_station
    current_train = choose_train
    return if current_train.nil?

    current_train.current_station.send_train(current_train)
    current_train.go_next_station
    current_train.current_station.accept_train(current_train)

    puts "Train №#{current_train.number} is moving back."
  end

  def show_stations_list
    puts "Stations: #{@stations_array}"
  end

  def show_trains_list_for_the_station
    puts 'There is no station!' if @stations_array.empty?

    @stations_array.each do |s|
      puts "Station name: #{s.name}"
      s.trains_block do |train|
        puts "Train number #{train.number}, #{train.type}"
        n = 0
        train.carriages_block { |carriage| puts "Number: #{n += 1}, #{carriage.show_info}" }
      end
    end
  end

  def upload_cargo(train)
    puts 'Input items count'
    items = gets.chomp.to_f

    train.carriages_block do |carriage|
      carriage.upload(items) if train.type == CargoTrain::TRAIN_TYPE
      break
    rescue StandardError
      next
    end
  end

  def upload_passenger(train)
    train.carriages_block do |carriage|
      carriage.buy_ticket if train.type == PassengerTrain::TRAIN_TYPE
      break
    rescue StandardError
      next
    end
  end

  def upload_train
    train = choose_train
    if train.type == CargoTrain::TRAIN_TYPE
      upload_cargo(train)
    else
      upload_passenger(train)
    end
    puts "It's done!"
  end
end
