require 'gosu'
include Gosu

(Dir.entries("data/scripts") - [".", ".."]).each{|script| require_relative("data/scripts/" + script)} #wczytywanie wszystkich skryptów z folderu skryptów

class GameWindow < Window #klasa okna gry
	def initialize
		super(640, 480, false) #konstruktor nadklasy Gosu::Window przyjmuje rozmiar i to, czy jest pełnoekranowe
		self.caption = "Klon Mario"
		
		$state = Game.new #tworzymy nowy stan gry
	end

	def update
		$state.update
	end

	def draw
		$state.draw
	end

	def button_down(id)
	end

	def button_up(id)
		$_keypress&.delete(id)
	end
end

GameWindow.new.show