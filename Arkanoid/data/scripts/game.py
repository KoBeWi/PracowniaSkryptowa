from data.scripts.objects import *
import random

class Game:
	def __init__(self, window):
		self.window = window
		self.objects = []
		
		paddle = Paddle()
		self.objects.append(paddle)
		self.objects.append(Ball(paddle))
		
		self.lifes = 3
		self.score = 0
		self.hiscore = 0
		self.clicked = False
		
		self.start = pygame.mixer.Sound("data/sfx/Start.wav")
		self.generate_level()
		
		self.background = pygame.image.load("data/gfx/Background.png")
		self.ball = pygame.image.load("data/gfx/Ball.png")
		self.fail = pygame.mixer.Sound("data/sfx/Fail.wav")
		self.ultrafail = pygame.mixer.Sound("data/sfx/FailHard.wav")
		self.font = pygame.font.SysFont("monospace", 30)
	
	def generate_level(self):
		self.wait_generate = False
		self.start.play()
		self.get_objects(Ball)[0].speed += 1
		i = 0
		
		for y in range(10):
			for x in range(10):
				if random.randrange(i+1) < 5:
					i += 1
					self.objects.append(Brick(x*80, y * 40))
	
	def update(self):
		for object in self.objects: object.update(self)
		self.objects = [object for object in self.objects if not hasattr(object, "destroyed")]
		
		if not self.get_objects(Brick) and not self.wait_generate:
			self.wait_generate = True
		
		self.clicked = False
	
	def draw(self):
		self.window.screen.blit(self.background, (0, 0))
		for object in self.objects: object.draw(self.window.screen)
		
		for i in range(self.lifes): self.window.screen.blit(self.ball, (30 + i*20, 30))
		self.window.screen.blit(self.font.render("Wynik: " + str(self.score), 1, (255,255,0)), (340, 20))
		if (self.hiscore): self.window.screen.blit(self.font.render("Najlepszy wynik: " + str(self.hiscore), 1, (255,255,0)), (240, 40))
	
	def click(self):
		self.clicked = True
	
	def get_objects(self, type):
		return [object for object in self.objects if isinstance(object, type)]