from data.scripts.objects import *

class Game:
	def __init__(self, window):
		self.window = window
		self.objects = []
		
		paddle = Paddle()
		self.objects.append(paddle)
		self.objects.append(Ball(paddle))
		
		for x in range(6):
			self.objects.append(Brick(160 + x*80, 160))
			self.objects.append(Brick(120 + x*80, 200))
		
		self.lifes = 3
		self.score = 0
		self.clicked = False
		
		self.background = pygame.image.load("data/gfx/Background.png")
		self.ball = pygame.image.load("data/gfx/Ball.png")
		self.font = pygame.font.SysFont("monospace", 30)
	
	def update(self):
		for object in self.objects: object.update(self)
		self.objects = [object for object in self.objects if not hasattr(object, "destroyed")]
		
		if not self.get_objects(Brick):
			self.score *= 2
		
		self.clicked = False
	
	def draw(self):
		self.window.screen.blit(self.background, (0, 0))
		for object in self.objects: object.draw(self.window.screen)
		
		for i in range(self.lifes): self.window.screen.blit(self.ball, (30 + i*20, 30))
		self.window.screen.blit(self.font.render("Wynik: " + str(self.score), 1, (255,255,0)), (340, 20))
	
	def click(self):
		self.clicked = True
	
	def get_objects(self, type):
		return [object for object in self.objects if isinstance(object, type)]