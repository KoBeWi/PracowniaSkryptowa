class Game #klasa stanu gry, która zajmuje się logiką
	attr_reader :map, :mario, :time #umożliwia czytanie tych zmiennych
	attr_accessor :coins #umożliwia czytanie i modyfikację
	
	def initialize
		@objects = [] #tablica na obiekty
		@map = Map.new(self) #tworzenie mapy
		@coins = 0 #liczba zebranych monet
		@time = 3600 #czas gry
		
		@mario = add_object(Mario.new(304, 288)) #dodajemy gracza do obiektów
	end
	
	def update
		@objects.each(&:update) #każdy obiekt robi swoje
		@objects.delete_if{|obj| obj.destroyed?} #usuwa obiekty, które mają ustawioną flagę usunięcia
		
		@time -= 1 #zmniejszamy czas
		snd("Time").play if Array.new(5) {|i| (i+1) * 60}.include?(@time) #w pięciu ostatnich sekundach gra dźwięk
		snd(@coins > $best_score ? "BestScore" : "WorseScore").play if @time == 0 #dźwięk grany na końcu rundy, w zależności czy pobiliśmy rekord
	end
	
	def draw
		@map.draw #rysowanie mapy
		@objects.each(&:draw) #rysowanie obiektów
		
		fnt("Courier New", 32).draw_rel("Wciśnij Enter, by zagrać ponownie", 320, 240, 3, 0.5, 0.5) if @time < -60 #mówi co robić, gdy koniec
		
		fnt("Courier New", 32).draw("Monety: #{@coins}", 16, 16, 3, 1, 1, Color::YELLOW) #aktualnie zebrane monety
		fnt("Courier New", 32).draw("Najlepszy wynik: #{$best_score}", 16, 48, 3, 1, 1, Color::YELLOW) if $best_score > 0 #najlepszy wynik
		fnt("Courier New", 32).draw("Czas: #{(@time/60.to_f).ceil}", 320, 16, 3, 1, 1, @time <= 300 ? Color::RED : Color::WHITE) if @time > 0 #pozostały czas
	end
	
	def add_object(object) @objects << object && object end #dodaje obiekt do tablicy obiektów i go zwraca
end