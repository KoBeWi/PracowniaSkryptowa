class Game #klasa stanu gry, która zajmuje się logiką
	attr_reader :map, :mario, :time
	attr_accessor :coins
	
	def initialize
		@objects = []
		@map = Map.new(self)
		@coins = 0
		@time = 3600
		
		@mario = add_object(Mario.new(304, 288))
	end
	
	def update
		@objects.each(&:update)
		@objects.delete_if{|obj| obj.destroyed?}
		@time -= 1
	end
	
	def draw
		@map.draw
		@objects.each(&:draw)
		
		fnt("Courier New", 32).draw("Monety: #{@coins}", 16, 16, 3, 1, 1, Color::YELLOW)
		fnt("Courier New", 32).draw("Czas: #{@time/60}", 320, 16, 3, 1, 1, @time <= 300 ? Color::RED : Color::WHITE) if @time > 0
	end
	
	def add_object(object) @objects << object && object end
end