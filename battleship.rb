class Battleship
	require 'matrix'
	def initialize
		createboard
	end

	def createboard
		comp_grid = [[*0..9],[*0..9],[*0..9],[*0..9],[*0..9],[*0..9],[*0..9],[*0..9],[*0..9],[*0..9]]
		# for i in 0..9
		# 	print "#{comp_grid[i]}\n" 
		# end
		puts comp_grid[1][1]
	end


end

Battleship.new()