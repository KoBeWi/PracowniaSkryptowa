require 'gosu'
include Gosu

(Dir.entries("data/scripts") - [".", ".."]).each{|script| require_relative("data/scripts/" + script)}

class GameWindow < Window
	def initialize
		super(640, 480, false)
		self.caption = "Klon Mario"
		
		$state = Game.new
	end

	def update
	end

	def draw
	end

	def button_down(id)
	end

	def button_up(id)
	end
end

GameWindow.new.show