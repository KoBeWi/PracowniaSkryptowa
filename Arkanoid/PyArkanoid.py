import pygame
from data.scripts.game import Game

class Window:
	def __init__(self, width = 800, height = 600):
		pygame.mixer.pre_init(44100, -16, 1, 512) #ta linijka naprawia dźwięki
		pygame.init() #inicjalizacja pygame
		self.screen = pygame.display.set_mode((width, height)) #inicjalizacja okna
		pygame.display.set_caption('PyArkanoid') #pasek tytułowy okna
		
		self.clock = pygame.time.Clock() #zegar używany w pętli gry
		self.state = Game(self) #obiekt stanu gry

	def show(self):
		while True: #pętla gry
			for event in pygame.event.get(): #obsługa zdarzeń
				if event.type == pygame.QUIT: #wyjście z gry
					return
				elif event.type == pygame.MOUSEBUTTONDOWN: #kliknięcie myszką
					self.state.click() #przesyła informację o kliknięciu
			
			self.clock.tick(60) #używamy zegara, żeby gra działała w 60 FPS
			self.state.update() #aktualizacja stanu gry
			self.screen.fill((0,0,0)) #czyszczenie ekranu
			self.state.draw() #rysowanie stanu gry
			pygame.display.update() #wrzucenie informacji graficznych do okna

if __name__ == "__main__":
	window = Window() #tworzy okno
	window.show() #uruchamia pętlę gry