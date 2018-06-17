class Map #klasa mapy
	def initialize(state)
		@tiles = [] #tablica kafelków
		@solid = {} #informacje o ścianach (hash dla szybkiego szukania)
		
		File.readlines("data/map.txt").each.with_index do |line, y| #czyta wszystkie linijki pliku
			line.chomp.each_char.with_index do |char, x| #przechodzi po każdej literze w linijce
				if char == "#" #krzyżyk oznacza punkt, gdzie mają pojawiać się monety
					state.add_object CoinSpawner.new(x, y) #tworzy nowy Spawner
				elsif char != "0" #numery 1-9 to indeks kafelka
					@tiles << Tile.new(x, y, char.to_i-1) #tworzy kafelek
					@solid[[x, y]] = true #ustawia zajęty punkt
				end
			end
		end
	end
	
	def draw
		img("Background").draw(0, 0, 0) #rysuje tło
		@tiles.each(&:draw) #rysuje kafelki
	end
	
	def solid?(x, y)
		@solid[[x, y]] #zwraca wartość ze zbioru zajętych kafelków
	end
end

class Tile #kafelek
	def initialize(x, y, id)
		@x, @y, @id = x, y, id
	end
	
	def draw
		tls("Tiles", 32, 32, @id).draw(@x * 32, @y * 32, 0) #rysuje kafelek o odpowiednim id
	end
end