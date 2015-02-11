module Battleship
	class Board
		SHIP_SIZES = {
			aircraft_carrier: 5,
			battleship: 4,
			submarine: 3,
			destroyer: 3,
			patrol_boat: 2
		}

		def initialize
		## create grid
			@coords = []
			10.times do @coords.push([*0..9]) end

			SHIP_SIZES.each do |ship|
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
				horizontal = [true, false].sample
				if horizontal == true
				# if horizontal
					block = [*x..x+(size-1)][y*3]
				else# if vertical
					block =[x*3][*y..y+(size-1)]
				end# test those coordinates against @coords
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
		private

		def random_number
			return [rand(9), rand(9)]
		end
	end
end

Battleship.new()