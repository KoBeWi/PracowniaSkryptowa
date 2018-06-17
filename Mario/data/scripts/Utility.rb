def img(name)
	$_images ||= {}
	$_images[name] ||= Image.new("data/gfx/" + name + ".png")
end

def tls(name, w, h, id)
	$_images ||= {}
	$_images[name] ||= Image.load_tiles("data/gfx/" + name + ".png", w, h)
	$_images[name][id]
end