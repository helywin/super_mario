class_name Hittable
extends StaticBody2D


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
func on_hit():
	pass
	
func reset():
	can_hit = true
	set_sprite()

func hit():
	if can_hit:
		on_hit()
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
