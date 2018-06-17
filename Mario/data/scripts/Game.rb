class Game #klasa stanu gry, która zajmuje się logiką
	attr_reader :map, :mario
	
	def initialize
		@objects = []
		@map = Map.new(self)
		
		@mario = add_object(Mario.new(304, 288))
	end
	
	def update
		@objects.each(&:update)
		@objects.delete_if{|obj| obj.destroyed?}
	end
	
	def draw
		@map.draw
		@objects.each(&:draw)
	end
	
	def add_object(object) @objects << object && object end
end