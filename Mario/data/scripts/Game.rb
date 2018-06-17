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
		
		fnt("Courier New", 32).draw_rel("Wciśnij Enter, by zagrać ponownie", 320, 240, 3, 0.5, 0.5) if @time < -60
		
		fnt("Courier New", 32).draw("Monety: #{@coins}", 16, 16, 3, 1, 1, Color::YELLOW)
		fnt("Courier New", 32).draw("Najlepszy wynik: #{$best_score}", 16, 48, 3, 1, 1, Color::YELLOW) if $best_score > 0
		fnt("Courier New", 32).draw("Czas: #{@time/60}", 320, 16, 3, 1, 1, @time < 360 ? Color::RED : Color::WHITE) if @time > 0
	end
	
	def add_object(object) @objects << object && object end
end