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

		turn(comp_board, human_board) ## not complete

	end

	def turn(comp_board, human_board)
		## human guess
		puts "Your turn"
		## check whether guess hits a ship
		if test_hit(human_guess, comp_board)
			puts "HIT!"
		else
			puts "missed"
		end
		## returnng the result

		# check whether game has ended	
		comp_guess = computer_guess
		## computer guess
		puts "Computer's turn"
		puts comp_guess
		if test_hit(comp_guess, human_board)
			puts "The computer hit"
		else
			puts "The computer missed"
		end
		## player told wehter it was a hit
		turn(comp_board, human_board)
		## check whether game has ended		
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
		player_board.ships.each do |ship|
			ship.coordinates.each do |ship_point|
				if ship_point.compare(coord_to_test)
					ship.hit_coords << coord_to_test
					puts "HIT!"
					if ship.hit_coords.size == ship.length
						puts "You sunk my battleship!"
					end
					return true
				end
			end		
		end
		return false
	end


	def computer_guess
		return random_coord
	end

	def human_guess
		puts "Guess x - must be between 0 and #{@board_size - 1}"	
		attempt_x = gets.chomp.to_i
		puts "Guess y - must be between 0 and #{@board_size - 1}"
		attempt_y = gets.chomp.to_i
		if not human_guess_validation(attempt_x, attempt_y)
			puts "Invalid guess, try again!"
			return human_guess
		end
		return Coord.new(attempt_x, attempt_y)
	end

	def human_guess_validation(attempt_x, attempt_y)
		if attempt_y > @board_size-1
			return false
		end
		if attempt_x > @board_size-1
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
	def initialize(player_name)
		@player_name = player_name
		@ships = []
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