class CoinSpawner
	@@coin_count = 0
	
	def initialize(x, y)
		@x, @y = x*32, y*32
	end
	
	def update
		if @@coin_count < 3 and !@coin and rand(300) == 0
			@coin = Coin.new(@x, @y)
			@@coin_count += 1
			$state.add_object(@coin)
		end
		
		true
	end
	
	def draw
	end
end

class Coin
	def initialize(x, y)
		@x, @y = x, y
	end
	
	def update
		true
	end
	
	def draw
		tls("Coin", 32, 32, milliseconds / 100 % 4).draw(@x, @y, 1)
	end
end