extends "res://blocks/Hittable.gd"


func _ready():
	hittable_sprite = $Origin/CoinBrick
	unhittable_sprite = $Origin/Brick
	hit_animation = $animation
	hit_audio = $hit_coin
	unhit_audio = $hit_brick
	pass # Replace with function body.

func on_hit(player_type: int):
	can_hit = false
	var item = load("res://items/LifeMushroom.tscn")
	var instance = item.instance()
	$Item.add_child(instance)
	instance.name = "Life"
	instance.spawn()
