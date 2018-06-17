def img(name)
	$_images ||= {}
	$_images[name] ||= Image.new("data/gfx/" + name + ".png")
end

def tls(name, w, h, id)
	$_images ||= {}
	$_images[name] ||= Image.load_tiles("data/gfx/" + name + ".png", w, h)
	$_images[name][id]
end

def fnt(name, size)
	$_fonts ||= {}
	$_fonts[[name, size]] ||= Font.new(size, name: name)
end

def key_press(key)
	$_keypress ||= {}
	return false if $_keypress[key]
	$_keypress[key] = true if button_down?(key)
end