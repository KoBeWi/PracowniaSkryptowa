import math
import pygame

class Brick:
	def __init__(self, x, y):
		self.texture = pygame.image.load("data/gfx/Brick.png")
		self.sound = pygame.mixer.Sound("data/sfx/Brick.wav")
		#^ grafika i dźwięk
		#\/ pozycja i rozmiar
		self.x = x
		self.y = y
		self.w = 80
		self.h = 40
	
	def update(self, state):
		pass #tu nic ciekawego się nie dzieje
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y)) #rysuje cegłę
	
	def destroy(self, state): #niszczenie cegły
		self.sound.play() #dźwięk zniszczenia
		self.destroyed = True #ustawia flagę zniszczenia (przez co potem cegła jest usuwana)
		state.score += 10 #dodaje wynik
		
class Paddle:
	def __init__(self): #tak samo jak w cegle
		self.texture = pygame.image.load("data/gfx/Paddle.png")
		self.sound = pygame.mixer.Sound("data/sfx/Paddle.wav")
		
		self.x = 320
		self.y = 560
		self.w = 160
		self.h = 20
	
	def update(self, state):
		self.x = min(max(0, pygame.mouse.get_pos()[0] - 80), 640) #podąża za myszką
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
		
class Ball:
	def __init__(self, paddle):
		self.texture = pygame.image.load("data/gfx/Ball.png")
		self.hit = pygame.mixer.Sound("data/sfx/Wall.wav")
		self.speed = 4 #szybkość piłki
		
		self.paddle = paddle #przypisuje paletkę
		self.reset() #ustawia stan początkowy
	
	def update(self, state):
		if state.clicked: self.started = True #jeśli się klikło, to piłka startuje
	
		if self.started: #jeśli wystartowała
			bricks = state.get_objects(Brick) #lista cegieł
		
			for i in range(self.speed): #pętla wykonywana szybkość razy
				check_brick = [brick for brick in bricks if self.collides(brick, self.vx, 0)] #sprawdza kolizję cegieł bokiem piłki
				if check_brick: #jeśli koliduje
					check_brick[0].destroy(state) #niszczy cegłę
					self.vx = -self.vx #piłka leci w drugą stronę
				elif self.vx < 0 and self.x <= 0 or self.vx > 0 and self.x >= 780: #kolizja z krawędzią ekranu
					self.hit.play() #dźwięk odbicia
					self.vx = -self.vx #też leci w drugą stronę
				else:
					self.x += self.vx #jak nie ma kolizji to przesuwa się jeden piksel
				
				check_brick = [brick for brick in bricks if self.collides(brick, 0, self.vy)] #to samo, ale pionowo
				if check_brick:
					check_brick[0].destroy(state)
					self.vy = -self.vy
				elif self.vy < 0 and (self.y <= 0):
					self.hit.play()
					self.vy = -self.vy
				elif self.vy > 0 and self.collides(self.paddle, 0, self.vy): #uderzenie w paletkę
					if state.wait_generate: #jeśli gra czeka na nowy poziom
						state.generate_level() #generujemy
						self.reset() #piłka się przykleja
					else:
						self.paddle.sound.play() #jak nie to normalnie się odbija i grany jest dźwięk paletki
						self.vx = ((self.x + 20) - (self.paddle.x + 80)) / 80.0 #prędkość pozioma zależy od tego, w które miejsce paletki się uderzy
						self.vy = -self.vy
				else:
					self.y += self.vy
			
			if self.y > 600: #jeśli piłka wyleci dołem poza ekran
				self.reset()
				if state.wait_generate: #generuje poziom, gdy potrzebny
					state.generate_level()
				
				state.lifes -= 1 #zmniejsza życia
				if state.lifes == 0: #jeśli się skończyły
					state.hiscore = max([state.score, state.hiscore]) #ustawia najlepszy wynik
					state.score = 0 #resetuje wynik
					state.lifes = 3 #i życia
					self.speed = 5 #i prędkość
					state.ultrafail.play() #i jest inny dźwięk
				else:
					state.fail.play()
		else:
			self.x = self.paddle.x + 70 #jeśli piłka nie wystartuje, ustawiana jest na pozycji paletki
	
	def draw(self, screen):
		screen.blit(self.texture, (self.x, self.y))
	
	def collides(self, object, dx, dy): #sprawdza, czy piłka koliduje z danym obiektem, przy danym przesunięciu
		return self.x + dx < object.x + object.w and self.x + dx + 20 > object.x and self.y + dy < object.y + object.h and self.y + dy + 20 > object.y
	
	def reset(self):
		self.y = 540 #wysokość tuż nad paletką
		self.x = self.paddle.x + 70 #środek paletki
		self.vx = 1 #prędkość ustawiana jest na góra-prawo
		self.vy = -1
		self.started = False #zatrzymuje piłkę