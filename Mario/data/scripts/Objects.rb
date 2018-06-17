class GameObject
	attr_reader :x, :y
	
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
		
		if button_down?(KbLeft) and @vx > -6
			@vx -= 1
			@mirrored = false
		elsif button_down?(KbRight) and @vx < 6
			@vx += 1
			@mirrored = true
		elsif !button_down?(KbLeft) and !button_down?(KbRight)
			@vx -= (@vx <=> 0)
		end
		
		if key_press(KbSpace) and on_floor?
			snd("Jump").play
			@vy = -16
		end
		
		if @vy > 0
			@vy.abs.to_i.times do
				if on_floor?
					@vy = 0
					break
				end
				@y += 1
			end
		elsif @vy < 0
			@vy.abs.to_i.times do
				if solid?(@x, @y - 1) or solid?(@x + 31, @y - 1)
					@vy = 0
					break
				end
				@y -= 1
			end
		end
		
		if @vx > 0
			@vx.abs.to_i.times do
				if solid?(@x + 32, @y) or solid?(@x + 32, @y + 63)
					@vx = 0
					break
				end
				@x += 1
			end
		elsif @vx < 0
			@vx.abs.to_i.times do
				if solid?(@x - 1, @y) or solid?(@x - 1, @y + 63)
					@vx = 0
					break
				end
				@x -= 1
			end
		end
		
		if !on_floor?
			@frame = 2
		elsif @vx != 0
			@frame = milliseconds / 100 % 2
		else
			@frame = 0
		end
	end
	
	def draw
		tls("Mario", 32, 64, @frame).draw(@x + (@mirrored ? 32 : 0), @y, 2, @mirrored ? -1 : 1)
	end
	
	def on_floor?
		solid?(@x, @y + 64) or solid?(@x + 31, @y + 64)
	end
end

class CoinSpawner < GameObject
	@@coin_count = 0
	
	def initialize(x, y)
		@x, @y = x*32, y*32
	end
	
	def update
		if $state.time == 0
			destroy
			@coin&.destroy
		end

		if @@coin_count < 3 and !@coin and rand(300) == 0
			@coin = Coin.new(@x, @y)
			@@coin_count += 1
			$state.add_object(@coin)
		end
		
		if @coin&.destroyed?
			@coin = nil
			@@coin_count -= 1
		end
	end
	
	def draw() end
end

class Coin < GameObject
	def initialize(x, y)
		@x, @y = x, y
	end
	
	def update
		if mario.x.between?(@x - 30, @x + 31) and mario.y.between?(@y - 62, @y + 31)
			snd("Coin").play
			destroy
			$state.coins += 1
		end
	end
	
	def draw
		tls("Coin", 32, 32, milliseconds / 100 % 4).draw(@x, @y, 1)
	end
end