class GameObject #klasa bazowa dla obiektów
	attr_reader :x, :y #pozwala czytać pozycję obiektu
	
	def mario #metoda pomocnicza dostępu do obiektu gracza
		$state.mario
	end
	
	def solid?(x, y) #metoda pomocnicza sprawdzająca, czy w danym punkcie jest ściana
		$state.map.solid?(x.div(32), y.div(32))
	end
	
	def destroy #niszczy obiekt
		@_destroyed = true
	end
	
	def destroyed? #zwraca, czy obiekt jest zniszczony
		@_destroyed
	end
end

class Mario < GameObject #gracz
	def initialize(x, y)
		@x, @y = x, y #pozycja
		@frame = 0 #aktualna klatka animacji
		@vx = @vy = 0 #prędkość pozioma i pionowa
	end
	
	def update
		@vy += 1 #zwiększa prędkość pionową (a.k.a. grawitacja)
		
		if button_down?(KbLeft) and @vx > -6 #gdy gracz idzie w lewo
			@vx -= 1 #zwiększa prędkość w lewo
			@mirrored = false #ustawia odwracanie grafiki
		elsif button_down?(KbRight) and @vx < 6 #to samo, ale w prawo
			@vx += 1
			@mirrored = true
		elsif !button_down?(KbLeft) and !button_down?(KbRight) #jeśli gracz stoi w miejscu
			@vx -= (@vx <=> 0) #postać hamuje
		end
		
		if key_press(KbSpace) and on_floor? #gdy wciśnie się Spacje i postać jest na ziemi
			snd("Jump").play #dźwięk skoku
			@vy = -16 #ustawia prędkość pionową w górę
		end
		
		if @vy > 0 #gdy prędkość pionowa jest dodatnia (spadanie)
			@vy.abs.to_i.times do #sprawdzanie kolizji piksel po pikselu
				if on_floor? #jeśli jest na ziemi
					@vy = 0 #zeruje prędkość
					break #i przerywa pętlę
				end
				@y += 1 #zmienia pozycję o piksel na każdą iterację pętli
			end
		elsif @vy < 0 #to samo, ale w górę
			@vy.abs.to_i.times do
				if solid?(@x, @y - 1) or solid?(@x + 31, @y - 1) #sprawdzanie kolizji z sufitem
					@vy = 0
					break
				end
				@y -= 1
			end
		end
		
		if @vx > 0 #to samo, ale w prawo
			@vx.abs.to_i.times do
				if solid?(@x + 32, @y) or solid?(@x + 32, @y + 63)
					@vx = 0
					break
				end
				@x += 1
			end
		elsif @vx < 0 #w lewo
			@vx.abs.to_i.times do
				if solid?(@x - 1, @y) or solid?(@x - 1, @y + 63)
					@vx = 0
					break
				end
				@x -= 1
			end
		end
		
		if !on_floor? #jeśli gracz jest w powietrzu
			@frame = 2 #animacja skoku
		elsif @vx != 0 #jeśli gracz jest na ziemi i idzie
			@frame = milliseconds / 100 % 2 #animacja chodzienia
		else
			@frame = 0 #animacja stania
		end
	end
	
	def draw #rysowanie
		tls("Mario", 32, 64, @frame).draw(@x + (@mirrored ? 32 : 0), @y, 2, @mirrored ? -1 : 1) #mirrored określa, czy grafika jest odwrócona
	end
	
	def on_floor?
		solid?(@x, @y + 64) or solid?(@x + 31, @y + 64) #sprawdza odpowiednie piksele, czy jest tam ziemia
	end
end

class CoinSpawner < GameObject #tworzy monety
	@@coin_count = 0 #liczba monet dzielona przez wszystkie obiekty klasy
	
	def initialize(x, y)
		@x, @y = x*32, y*32
	end
	
	def update
		if @@coin_count < 3 and !@coin and rand(300) == 0 #jeśli są mniej niż 3 monety na mapie to losowo tworzy monetę na sobie (jeśli już nie ma)
			@coin = Coin.new(@x, @y) #tworzona moneta
			@@coin_count += 1 #zwiększa licznik monet
			$state.add_object(@coin) #dodaje monetę do stanu gry
		end
		
		if @coin&.destroyed? #jeśli moneta jest zniszczona
			@coin = nil #kasujemy referencję
			@@coin_count -= 1 #zmniejszamy liczbę monet
		end
		
		if $state.time == 0 #jeśli kończy się czas
			destroy #niszczy się
			@coin&.destroy #niszczy monetę, jeśli istnieje
		end
	end
	
	def draw() end #nic nie rysuje
end

class Coin < GameObject #moneta
	def initialize(x, y)
		@x, @y = x, y
	end
	
	def update
		if mario.x.between?(@x - 30, @x + 31) and mario.y.between?(@y - 62, @y + 31) #sprawdza, czy gracz jest wewnątrz monety
			snd("Coin").play #dźwięk zebrania monety
			destroy #niszczy monetę
			$state.coins += 1 #zwiększa licznik monet (wynik)
		end
	end
	
	def draw
		tls("Coin", 32, 32, milliseconds / 100 % 4).draw(@x, @y, 1) #rysuje animowaną monetę
	end
end