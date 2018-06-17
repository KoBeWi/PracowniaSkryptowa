def img(name) #metoda pomocnicza do wczytywania obrazków
	$_images ||= {} #hash na obrazki jest tworzony, gdy nie istnieje
	$_images[name] ||= Image.new("data/gfx/" + name + ".png") #zwraca obrazek, wczytując go, gdy odwołujemy się pierwszy raz
end

def tls(name, w, h, id) #metoda do wczytywania kafelków z obrazków
	$_images ||= {}
	$_images[name] ||= Image.load_tiles("data/gfx/" + name + ".png", w, h)
	$_images[name][id]
end

def snd(name) #metoda do wczytywania dźwięków
	$_samples ||= {}
	$_samples[name] ||= Sample.new("data/sfx/" + name + ".ogg")
end

def fnt(name, size) #metoda do wczytywania czcionek
	$_fonts ||= {}
	$_fonts[[name, size]] ||= Font.new(size, name: name)
end

def key_press(key) #metoda zwracająca true, gdy wciśnie się klawisz
	$_keypress ||= {} #wciśnięte klawisze
	return false if $_keypress[key] #zwraca false, dopóki klawisz nie jest puszczony
	$_keypress[key] = true if button_down?(key) #ustawia klawisz jeśli jest wciśnięty
end