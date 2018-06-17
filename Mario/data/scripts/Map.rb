class Map
	def initialize
		@tiles = []
		
		File.readlines("data/map.txt").each.with_index do |line, y|
			line.chomp.each_char.with_index do |char, x|
				@tiles << Tile.new(x, y, char.to_i-1) if char != "0"
			end
		end
	end
	
	def draw
		@tiles.each(&:draw)
	end
end

class Tile
	def initialize(x, y, id)
		@x, @y, @id = x, y, id
	end
	
	def draw
		tls("Tiles", 32, 32, @id).draw(@x * 32, @y * 32, 0)
	end
end