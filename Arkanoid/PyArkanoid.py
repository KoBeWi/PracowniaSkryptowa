import pygame
from data.scripts.game import Game

class Window:
    def __init__(self, width = 800, height = 600):
        pygame.init()
        self.width = width
        self.height = height
        self.screen = pygame.display.set_mode((width, height))
        pygame.display.set_caption('PyArkanoid')
        
        self.clock = pygame.time.Clock()
        self.state = Game(self)
    
    def show(self):
        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return
                    
            self.clock.tick(60)
            self.update()
            self.screen.fill((0,0,0))
            self.draw()
            pygame.display.update()
    
    def update(self):
        self.state.update()
    
    def draw(self):
        self.state.draw()

if __name__ == "__main__":
    window = Window()
    window.show()