class Game #klasa stanu gry, która zajmuje się logiką
	def initialize
		@map = Map.new
	end
	
	def update
	end
	
	def draw
		@map.draw
	end
end