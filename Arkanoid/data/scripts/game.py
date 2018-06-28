from data.scripts.objects import *

class Game:
	def __init__(self, window):
		self.window = window
		self.objects = []
		
		paddle = Paddle()
		self.objects.append(paddle)
		self.objects.append(Ball(paddle))
		self.objects.append(Brick(160, 160))
		self.clicked = False
		
		self.background = pygame.image.load("data/gfx/Background.png")
	
	def update(self):
		for object in self.objects: object.update(self)
		self.clicked = False
	
	def draw(self):
		self.window.screen.blit(self.background, (0, 0))
		for object in self.objects: object.draw(self.window.screen)
	
	def click(self):
		self.clicked = True
	
	def get_objects(self, type):
		return [object for object in self.objects if isinstance(object, type)]