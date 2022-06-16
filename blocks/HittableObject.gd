class_name HittableObject
extends StaticBody2D


export (bool) var HIT_MOVE = true
export (bool) var HIT_REPEAT = false
export (bool) var HIT_REPEAT_SECOND = 5
export (String) var UNHIT_TEXTURE = "res://blocks/HittableCoin.tscn::5" 

var can_hit = true
var hittable_sprite
var unhittable_sprite
var hit_animation
var hit_audio
var unhit_audio


func _ready():
	pass
	
func set_sprite():
		hittable_sprite.visible = can_hit
		unhittable_sprite.visible = !can_hit

# 需要重载
func on_hit(player_type: int):
	pass
	
func reset():
	can_hit = true
	set_sprite()

func hit(player_type: int):
	if can_hit:
		on_hit(player_type)
		if hit_audio:
			hit_audio.play()
		if hit_animation:
			hit_animation.play("hit")
		else:
			set_sprite()
		return true
	else:
		if unhit_audio:
			unhit_audio.play()
		return false
		
func on_hit_animation_animation_finished(anime_name : String):
	set_sprite()
