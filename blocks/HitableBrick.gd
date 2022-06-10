extends "res://blocks/Hittable.gd"


func _ready():
	hittable_sprite = $Sprite
	unhittable_sprite = $Sprite2
	hit_animation = $animation
	hit_audio = $hit_break
	unhit_audio = $hit_brick
	connect_signals()
	pass # Replace with function body.

func on_hit():
	pass
