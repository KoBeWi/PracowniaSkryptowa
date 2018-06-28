import math
import pygame

class Brick:
	def __init__(self, x, y):
		self.texture = pygame.image.load("data/gfx/Brick.png")
		self.x = x
		self.y = y
		self.w = 80
		self.h = 40
	
	def update(self, state):
		pass
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Paddle:
	def __init__(self):
		self.texture = pygame.image.load("data/gfx/Paddle.png")
		self.x = 320
		self.y = 560
		self.w = 160
		self.h = 20
	
	def update(self, state):
		self.x = min(max(0, pygame.mouse.get_pos()[0] - 80), 640)
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Ball:
	SPEED = 5
	
	def __init__(self, paddle):
		self.texture = pygame.image.load("data/gfx/Ball.png")
		self.paddle = paddle
		self.x = 390
		self.y = 540
		self.vx = 1
		self.vy = -1
		self.started = False
	
	def update(self, state):
		if state.clicked: self.started = True
	
		if self.started:
			for i in range(self.SPEED):
				if self.vx < 0 and (self.x <= 0) or self.vx > 0 and (self.x >= 780):
					self.vx *= -1
				else:
					self.x += self.vx
				
				if self.vy < 0 and (self.y <= 0) or self.vy > 0 and (self.collides(self.paddle)):
					self.vy *= -1
				else:
					self.y += self.vy
			
			if self.y > 600:
				self.y = 540
				self.x = self.paddle.x + 70
				self.vx = 1
				self.vy = -1
				self.started = False
		else:
			self.x = self.paddle.x + 70
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
	
	def collides(self, object):
		return self.x < object.x + object.w and self.x + 20 > object.x and self.y < object.y + object.h and self.y + 20 > object.y