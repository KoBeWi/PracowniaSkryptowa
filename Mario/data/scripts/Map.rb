class Map
	def initialize(state)
		@tiles = []
		
		File.readlines("data/map.txt").each.with_index do |line, y|
			line.chomp.each_char.with_index do |char, x|
				if char == "#"
					state.add_object CoinSpawner.new(x, y)
				elsif char != "0"
					@tiles << Tile.new(x, y, char.to_i-1)
				end
			end
		end
	end
	
	def draw
		img("Background").draw(0, 0, 0)
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