class GameObject
	def mario
		$state.mario
	end
	
	def solid?(x, y)
		$state.map.solid?(x.div(32), y.div(32))
	end
	
	def destroy
		@destroyed = true
	end
	
	def destroyed?
		@destroyed
	end
end

class Mario < GameObject
	def initialize(x, y)
		@x, @y = x, y
		@frame = 0
		@vx = @vy = 0
	end
	
	def update
		@vy += 1
	end
	
	def draw
		tls("Mario", 32, 64, @frame).draw(@x, @y, 2)
	end
end

class CoinSpawner < GameObject
	@@coin_count = 0
	
	def initialize(x, y)
		@x, @y = x*32, y*32
	end
	
	def update
		@coin = nil if @coin&.destroyed?
		
		if @@coin_count < 3 and !@coin and rand(300) == 0
			@coin = Coin.new(@x, @y)
			@@coin_count += 1
			$state.add_object(@coin)
		end
	end
	
	def draw() end
end

class Coin < GameObject
	def initialize(x, y)
		@x, @y = x, y
	end
	
	def update
	end
	
	def draw
		tls("Coin", 32, 32, milliseconds / 100 % 4).draw(@x, @y, 1)
	end
end