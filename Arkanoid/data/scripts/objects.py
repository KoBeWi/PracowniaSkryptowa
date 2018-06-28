import pygame

class Brick:
	def __init__(self, x, y):
		self.texture = pygame.image.load("data/gfx/Brick.png")
		self.x = x
		self.y = y
	
	def update(self):
		pass
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Paddle:
	def __init__(self):
		self.texture = pygame.image.load("data/gfx/Paddle.png")
		self.x = 320
		self.y = 560
	
	def update(self):
		self.x = min(max(0, pygame.mouse.get_pos()[0] - 80), 640)
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Ball:
	def __init__(self):
		self.texture = pygame.image.load("data/gfx/Ball.png")
		self.x = 390
		self.y = 540
	
	def update(self):
		pass
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))