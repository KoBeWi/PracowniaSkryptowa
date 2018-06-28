from data.scripts.objects import *
import random

class Game:
	def __init__(self, window):
		self.window = window #zapamiętuje okno
		self.objects = [] #lista obiektów gry
		#podstawowe obiekty \/
		paddle = Paddle()
		self.objects.append(paddle)
		self.objects.append(Ball(paddle))
		#różne zmienne gry \/
		self.lifes = 3
		self.score = 0
		self.hiscore = 0
		self.clicked = False
		
		#wczytywanie grafik i dźwięków \/
		self.background = pygame.image.load("data/gfx/Background.png")
		self.ball = pygame.image.load("data/gfx/Ball.png")
		self.start = pygame.mixer.Sound("data/sfx/Start.wav")
		self.fail = pygame.mixer.Sound("data/sfx/Fail.wav")
		self.ultrafail = pygame.mixer.Sound("data/sfx/FailHard.wav")
		self.font = pygame.font.SysFont("monospace", 30)
		
		self.generate_level() #generowanie planszy
	
	def generate_level(self):
		self.wait_generate = False #jeśli czekał na generację, to przestaje
		self.start.play() #dźwięk startu
		self.get_objects(Ball)[0].speed += 1 #zwiększamy szybkość piłki
		
		i = 0 #licznik cegieł
		for y in range(10): #cegły są gennerowane na siatce 10x10
			for x in range(10):
				if random.randrange(i+1) < 5: #im więcej cegieł, tym mniejsza szansa, że utworzy się kolejna
					i += 1
					self.objects.append(Brick(x*80, y * 40)) #tworzy cegłę i wrzuca do listy obiektów
	
	def update(self):
		for object in self.objects: object.update(self) #aktualizuje obiekty
		self.objects = [object for object in self.objects if not hasattr(object, "destroyed")] #usuwa obiekty oznaczone jako "zniszczone"
		
		if not self.get_objects(Brick) and not self.wait_generate: #jeśli zniszczymy cegły
			self.wait_generate = True #to oczekuje na generację
		
		self.clicked = False #odklikuje
	
	def draw(self):
		self.window.screen.blit(self.background, (0, 0)) #tło
		for object in self.objects: object.draw(self.window.screen) #rysowanie obiektów
		
		for i in range(self.lifes): self.window.screen.blit(self.ball, (30 + i*20, 30)) #rysowanie żyć
		self.window.screen.blit(self.font.render("Wynik: " + str(self.score), 1, (255,255,0)), (340, 20)) #wynik
		if (self.hiscore): self.window.screen.blit(self.font.render("Najlepszy wynik: " + str(self.hiscore), 1, (255,255,0)), (240, 40)) #najlepszy wynik, gdy niezerowy
	
	def click(self):
		self.clicked = True #klika
	
	def get_objects(self, type): #zwraca wszystkie obiekty danego typu
		return [object for object in self.objects if isinstance(object, type)]