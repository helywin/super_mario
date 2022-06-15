extends "res://blocks/Hittable.gd"


func _ready():
	hittable_sprite = $Origin/CoinBrick
	unhittable_sprite = $Origin/Brick
	hit_animation = $animation
	hit_audio = $hit_coin
	unhit_audio = $hit_brick
	hit_animation.connect("animation_finished", self, "on_hit_animation_animation_finished")
	pass # Replace with function body.

func on_hit(player_type: int):
	can_hit = false
