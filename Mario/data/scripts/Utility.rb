def img(name)
	$_images ||= {}
	$_images[name] ||= Image.new("data/gfx/" + name + ".png")
end