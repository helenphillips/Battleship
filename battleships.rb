class Battleships
	SHIP_SIZES = {
		:aircraft_carrier => 5,
		:battleship => 4,
		:submarine => 3,
		:destroyer => 3,
		:patrol_boat => 1
	}



	def initialize
		@board_size = 10
		comp_board = Board.new("computer")
		human_board = Board.new("human")
		SHIP_SIZES.each_pair do |ship, size|
			ship_placing(ship, size, 1000, comp_board)
			ship_placing(ship, size, 1000, human_board)
		end

		round(comp_board, human_board) 

	end



	def round(comp_board, human_board)
		## human guess
		puts "Your turn"

		turn("Human", human_guess, comp_board)

		turn("Computer", computer_guess, human_board)

		round(comp_board, human_board)
		## check whether game has ended		
	end

	def turn(player, guess, opponents_board)
		a_turn = test_hit(guess, opponents_board)
		case a_turn
		when Coord
			puts "You tried that already" unless player == "Computer"
			turn(player, human_guess, opponents_board)
		when true
			puts "The #{player} hit"
		when false
			puts "The #{player} missed"
		
		end
		## player told wehter it was a hit

	end


	def ship_placing(ship, size, num_tries, player_board)
		if num_tries == 0
			return
		end	
		test_coord = random_coord
		
		coords_to_test = []
		vertical = is_vertical


		if vertical
			if test_coord.x + size < @board_size
				[*test_coord.x..(test_coord.x+(size-1))].each do |x|
					coords_to_test << Coord.new(x, test_coord.y)
				end
			else
				return ship_placing(ship, size, num_tries-1, player_board)
			end
		else
			if test_coord.y + size < @board_size
				[*test_coord.y..(test_coord.y+(size-1))].each do |y|
					coords_to_test << Coord.new(test_coord.x, y)
				end
			else
				return ship_placing(ship, size, num_tries-1, player_board)
			end
		end
		
		if test_coords_valid(coords_to_test, player_board) == false
			return ship_placing(ship, size, num_tries-1, player_board)
		end
		my_ship = Ship.new(ship, size, coords_to_test)
		puts player_board.player_name
		puts my_ship.coordinates
		player_board.ships << my_ship
	
	end

	def is_vertical()
		orientation = rand(2)
		if(orientation == 1)
			return true
		else 
			return false
		end
	end


	def random_coord
		return Coord.new(rand(10), rand(10))
	end

	def test_coords_valid(coords_to_test, player_board)
		player_board.ships.each do |ship|
			ship.coordinates.each do |ship_point|
				coords_to_test.each do |tester|
					if ship_point.compare(tester)
						return false
					end
				end
			end		
		end
		return true
	end

	def test_hit(coord_to_test, player_board)
		if(already_tried?(coord_to_test, player_board))
			return coord_to_test
		else	
			player_board.coords_used << coord_to_test  
		end
		player_board.ships.each do |ship|
			ship.coordinates.each do |ship_point|
				if ship_point.compare(coord_to_test)
					ship.hit_coords << coord_to_test
					puts "HIT!"
					
					if ship.hit_coords.size == ship.length
						puts "You sunk my battleship!"
						
						if game_won(player_board)
							puts "#{player_board.player_name} was beaten. GAME OVER!"
							exit
						end

					end
					return true
				end
			end		
		end
		return false
	end

	def already_tried?(coord_to_test, player_board)
		player_board.coords_used.map{|coord| [coord.x, coord.y]}.include? [coord_to_test.x, coord_to_test.y]
	end


	def game_won(player_board)
		ships_sunk = player_board.ships.inject([]){| arr, ship|
			arr << (ship.hit_coords.size == ship.length)
		}

		ships_sunk.all?{ |a| a == true}

	end

	def computer_guess
		return random_coord
	end

	def human_guess
		puts "Guess x - must be between 0 and #{@board_size - 1}"	
		attempt_x = gets.chomp
		puts "Guess y - must be between 0 and #{@board_size - 1}"
		attempt_y = gets.chomp
		if not human_guess_validation(attempt_x, attempt_y)
			puts "Invalid guess, try again!"
			return human_guess
		end
		return Coord.new(attempt_x.to_i, attempt_y.to_i)
	end

	def human_guess_validation(attempt_x, attempt_y)
		if attempt_x.empty? || attempt_y.empty?
			return false
		end

		if attempt_y.to_i > @board_size-1 || attempt_x.to_i > @board_size-1
			return false
		end
		
		return true
	end
end 

class Ship
	attr_accessor :name
	attr_accessor :length
	attr_accessor :coordinates
	attr_accessor :hit_coords
	def initialize(name, length, coordinates)
		@name = name
		@length = length
		@coordinates = coordinates
		@hit_coords = []		
	end
end

class Board
	attr_accessor :player_name
	attr_accessor :ships
	attr_accessor :coords_used
	def initialize(player_name)
		@player_name = player_name
		@ships = []
		@coords_used = []
	end
end

class Coord
	attr_accessor :x
	attr_accessor :y
	def initialize(x, y)
		@x = x
		@y = y
	end

	def to_s
		return "#{@x},#{@y}"
	end

	def compare(tester)
		tester.x == @x and tester.y == @y
	end
end

Battleships.new