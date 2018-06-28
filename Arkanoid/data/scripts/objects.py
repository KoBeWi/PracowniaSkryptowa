import math
import pygame

class Brick:
	def __init__(self, x, y):
		self.texture = pygame.image.load("data/gfx/Brick.png")
		self.sound = pygame.mixer.Sound("data/sfx/Brick.wav")
		
		self.x = x
		self.y = y
		self.w = 80
		self.h = 40
	
	def update(self, state):
		pass
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
	
	def destroy(self, state):
		self.sound.play()
		self.destroyed = True
		state.score += 10
		
class Paddle:
	def __init__(self):
		self.texture = pygame.image.load("data/gfx/Paddle.png")
		self.sound = pygame.mixer.Sound("data/sfx/Paddle.wav")
		
		self.x = 320
		self.y = 560
		self.w = 160
		self.h = 20
	
	def update(self, state):
		self.x = min(max(0, pygame.mouse.get_pos()[0] - 80), 640)
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Ball:
	def __init__(self, paddle):
		self.texture = pygame.image.load("data/gfx/Ball.png")
		self.hit = pygame.mixer.Sound("data/sfx/Wall.wav")
		self.speed = 4
		
		self.paddle = paddle
		self.reset()
	
	def update(self, state):
		if state.clicked: self.started = True
	
		if self.started:
			bricks = state.get_objects(Brick)
		
			for i in range(self.speed):
				check_brick = [brick for brick in bricks if self.collides(brick, self.vx, 0)]
				if check_brick:
					check_brick[0].destroy(state)
					self.vx = -self.vx
				elif self.vx < 0 and (self.x <= 0) or self.vx > 0 and (self.x >= 780):
					self.hit.play()
					self.vx = -self.vx
				else:
					self.x += self.vx
				
				check_brick = [brick for brick in bricks if self.collides(brick, 0, self.vy)]
				if check_brick:
					check_brick[0].destroy(state)
					self.vy = -self.vy
				elif self.vy < 0 and (self.y <= 0):
					self.hit.play()
					self.vy = -self.vy
				elif self.vy > 0 and self.collides(self.paddle, 0, self.vy):
					if state.wait_generate:
						state.generate_level()
						self.reset()
					else:
						self.paddle.sound.play()
						self.vx = ((self.x + 20) - (self.paddle.x + 80)) / 80.0
						self.vy = -self.vy
				else:
					self.y += self.vy
			
			if self.y > 600:
				self.reset()
				if state.wait_generate:
					state.generate_level()
				
				state.lifes -= 1
				if state.lifes == 0:
					state.lifes = 3
					state.hiscore = max([state.score, state.hiscore])
					state.score = 0
					self.speed = 5
					state.ultrafail.play()
				else:
					state.fail.play()
		else:
			self.x = self.paddle.x + 70
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
	
	def collides(self, object, dx, dy):
		return self.x + dx < object.x + object.w and self.x + dx + 20 > object.x and self.y + dy < object.y + object.h and self.y + dy + 20 > object.y
	
	def reset(self):
		self.y = 540
		self.x = self.paddle.x + 70
		self.vx = 1
		self.vy = -1
		self.started = False