require 'gosu'
include Gosu

(Dir.entries("data/scripts") - [".", ".."]).each{|script| require_relative("data/scripts/" + script)} #wczytywanie wszystkich skryptów z folderu skryptów

class GameWindow < Window #klasa okna gry
	def initialize
		super(640, 480, false) #konstruktor nadklasy Gosu::Window przyjmuje rozmiar i to, czy jest pełnoekranowe
		self.caption = "Klon Mario"
		
		$best_score = 0
		$state = Game.new #tworzymy nowy stan gry
	end

	def update #wywoływane co klatkę
		$state.update #aktualizujemy stan gry
	end

	def draw #wywoływane co klatkę naprzemiennie z update
		$state.draw #rysujemy stan gry
	end

	def button_down(id) #wywoływane na poczatku klatki, gdy klawisz jest właśnie wciśnięty
		if id == KbReturn and $state.time <= 0 #gdy wciśnie się Enter, gra się restartuje
			snd("Restart").play #dźwięk restartu
			$best_score = [$state.coins, $best_score].max #aktualizujemy najlepszy wynik, gdy był lepszy
			$state = Game.new #gra zaczyna się od nowa
		end
	end

	def button_up(id) #wywoływane, gdy klawisz jest właśnie pusczony
		$_keypress&.delete(id) #zwalnia przycisk (patrz: Utility.rb)
	end
end

GameWindow.new.show