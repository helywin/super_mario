extends BitmapFont


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const graphy = String("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
const format_str = "res://font/textures/%s.tres"
const rec = Rect2(0,0,8,8)

func load_texture(name : String, utf8 : int):
	var tex = load(format_str % name)
	add_texture(tex)
	add_char(utf8, 0, tex.region)
	pass

func _init():
	for ch in graphy:
		var tex = load(format_str % ch)
		var utf8_bytes = ch.to_utf8()
		var utf8 = ""
		for b in utf8_bytes:
			utf8 += String(b)
		load_texture(ch, utf8.to_int())
	load_texture("dot", 0x2e)
	load_texture("copyright", 0xA9)
	load_texture("times", 0xd7)
	load_texture("minus", 0x2d)
	load_texture("exc", 0x21)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
