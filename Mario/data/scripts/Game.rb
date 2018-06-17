class Game #klasa stanu gry, która zajmuje się logiką
	def initialize
		@objects = []
		@map = Map.new(self)
	end
	
	def update
		@objects.select!(&:update)
	end
	
	def draw
		@map.draw
		@objects.each(&:draw)
	end
	
	def add_object(object) @objects << object end
end