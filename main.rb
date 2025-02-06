require_relative 'train'
require_relative 'carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'route'
require_relative 'station'

class Logistic
  MENU = [{ id: 1, title: "create station", action: :create_station, description: "create new station" },
          { id: 2, title: "create train", action: :create_train, description: "create passenger or cargo train" },
          { id: 3, title: "create route", action: :create_route, description: "create new route" },
          { id: 4, title: "create carriage", action: :create_carriage, description: "create passenger or cargo carriage" },
          { id: 5, title: "add route station", action: :add_route_station, description: "add existed or new station to the route" },
          { id: 6, title: "remove route station", action: :remove_route_station, description: "remove station from route" },
          { id: 7, title: "assign route for train", action: :assign_route_for_train, description: "assign existed route for existed train" },
          { id: 8, title: "add carriage to train", action: :add_carriage_to_train, description: "add carriage to train" },
          { id: 9, title: "remove carriage from train", action: :remove_carriage_from_train, description: "remove carriage from train" },
          { id: 10, title: "move train to the next station", action: :move_train_to_the_next_station, description: "move train to the next route station" },
          { id: 11, title: "move train to the previous station", action: :move_train_to_the_previous_station, description: "move train to the previous route station" },
          { id: 12, title: "show stations list", action: :show_stations_list, description: "show stations list" },
          { id: 13, title: "show trains list for the station", action: :show_trains_list_for_the_station, description: "show trains list for the station" },
          { id: 14, title: "exit", action: :stop, description: "exit" },
          { id: 15, title: "show commands", action: :help, description: "show commands" }]

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
      get_action if @command
      do_action
      break if @break
    end
  end

  private

  def welcome_text
    puts "Welcome to HAPPY LOGISTIC INTERFACE"
    puts "Input 'help' to show commands!"
  end

  def ask_action
    puts "Input command number, please."
    command_index = gets.chomp
    @command = MENU.find { |item| item[:id] == command_index.to_i }
    puts "Command #{command_index} NOT FOUND! Input 'help' to view full command list." unless @command
  end

  def get_action
    @command[:action]
  end

  def do_action
    send get_action
  end

  def stop
    puts "Thanks fot your attention!"
    @break = true
  end

  def help
    MENU.each do |item|
      printf "%-2s %-50s %s\n", item[:id], item[:action], item[:description]
    end
  end

  def create_new_station(name)
    new_station = Station.new(name)
    @stations_array << new_station

    new_station
  end

  def choose_route
    unless @routes_array.empty?
      puts "Choose the route:"
      puts "routes - #{@routes_array}"
      @routes_array.each do |r|
        puts "#{r.show} - this one? (y/n)"
        return r if gets.chomp == 'y'
      end
    end
    puts "There is no route!"
  end

  def choose_train
    unless @trains_array.empty?
      puts "Choose the train:"
      @trains_array.each do |t|
        puts "#{t.type} train number #{t.number} - this one? (y/n)"
        return t if gets.chomp == 'y'
      end
    end
    puts "There is no train!"
  end

  def choose_type
    puts "Train type: passenger or cargo"
    gets.chomp.upcase.to_sym
  end

  def succeed_message(text)
    puts "#{text} successfully created"
  end

  def create_station
    puts "Station name:"
    name = gets.chomp
    create_new_station name
    succeed_message "Station #{name}"
  end

  def create_train
    type = choose_type

    puts "Train number:"
    number = gets.chomp
    @trains_array << Train.new(number, type)

    succeed_message "#{type} train №'#{number}'"
  end

  def create_carriage
    type = choose_type

    puts "Carriage number:"
    number = gets.chomp
    @trains_array << Carriage.new(type)

    succeed_message "#{type} carriage №'#{number}'"
  end

  def create_route
    puts "Route start station name:"
    start_station_name = gets.chomp

    puts "Route finish station name:"
    finish_station_name = gets.chomp

    start_station = @stations_array.find { |s| s.name == start_station_name } || create_new_station(start_station_name)
    finish_station = @stations_array.find { |s| s.name == finish_station_name } || create_new_station(finish_station_name)

    @routes_array << Route.new(start_station, finish_station)

    succeed_message "Route from '#{start_station_name}' to '#{finish_station_name}'"
  end

  def add_route_station # add route station
    current_route = choose_route
    return if current_route.nil?

    unless current_route.nil?
      puts "Chose station name from #{@stations_array.map { |station| station.name }} or input new one."
      station_name = gets.chomp
      current_route.add_station(@stations_array.find { |s| s.name == station_name } || create_new_station(station_name))
      puts "Station add to route #{current_route.show}"
    else
      puts "Route not found"
    end
  end

  def remove_route_station
    current_route = choose_route
    return if current_route.nil?

    current_route.stations.each do |station|
      puts "Do you want to delete #{station.name}? (y/n)"
      if gets.chomp == 'y'
        current_route.drop_station(station)
      end
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

  def add_carriage_to_train
    current_train = choose_train
    return if current_train.nil?

    current_carriage = Carriage.new(current_train.type)
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
    if @stations_array.empty?
      puts "There is no station!"
      return
    end

    type = choose_type
    @stations_array.each do |s|
      puts "#{s.name} - #{s.trains_by_type(type)}"
    end
  end
end
