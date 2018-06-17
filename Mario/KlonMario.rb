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

	def update
		$state.update
	end

	def draw
		$state.draw
	end

	def button_down(id)
		if id == KbReturn and $state.time <= 0
			$best_score = [$state.coins, $best_score].max
			$state = Game.new
		end
	end

	def button_up(id)
		$_keypress&.delete(id)
	end
end

GameWindow.new.show