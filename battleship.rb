## module Battleship
	class Board
		SHIP_SIZES = {
			:aircraft_carrier => 5,
			:battleship => 4,
			:submarine => 3,
			:destroyer => 3,
			:patrol_boat => 2
		}

		def initialize
		## create grid
			@coords = []
			10.times{@coords.push([*0..9])}

			SHIP_SIZES.each_pair do |ship, size|
				numbers =random_number
				x = numbers[0]
				y = numbers[1]
				
				if @coords[x][y].class != String
					add_ship(size, numbers)
				else
					test = true
					while test
						numbers = random_number
						x = numbers[0]
						y = numbers[1]
						if @coords[x][y].class != String
							add_ship(size, numbers)
							test = false
						end
					end
				end
			end
		end

		def add_ship(size, coords)
			# vertical or horizontal
			
			ok = true
			while ok
				x, y = random_number # destructuring the array
				horizontal = [true, false].choice
				if horizontal == true
				# if horizontal
					block_x = [*x..x+(size-1)]
					block_y = []
					size.times{block_y << y}
					puts block_y
					puts block_x
				else# if vertical
					block_x =[]
					size.times{block_x << x}
					block_y = [*y..y+(size-1)]
					puts block_y
					puts block_x
				end# test those coordinates against @coords
				block = [block_x, block_y]
				if !@coords[block].slice(size).include?('x')
					@coords[block].each do |item|
						item = 'x'
					end
					ok = false
				end
			end
		end


		def attack(x, y)
			if @coords[x][y] == String
				puts "Hit!"
			else
				puts "Miss!"
			end
		end
		private

		def random_number
			return [rand(9), rand(9)]
		end

		def find_point
			## function to take a multi-dimensional arrays to get a coordinate
		end
	end
## end

Board.new()