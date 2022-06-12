extends "res://blocks/Hittable.gd"


func _ready():
	hittable_sprite = $Origin/CoinBrick
	unhittable_sprite = $Origin/Brick
	hit_animation = $animation
	hit_audio = $hit_coin
	unhit_audio = $hit_brick
	pass # Replace with function body.

func on_hit():
	can_hit = false
	$Item.spawn()
