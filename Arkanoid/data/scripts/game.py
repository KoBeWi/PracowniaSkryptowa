from data.scripts.objects import *

class Game:
	def __init__(self, window):
		self.window = window
		self.objects = []
		
		self.objects.append(Paddle())
		self.objects.append(Ball())
		self.objects.append(Brick(160, 160))
	
	def update(self):
		for object in self.objects: object.update()
	
	def draw(self):
		for object in self.objects: object.draw(self.window.screen)