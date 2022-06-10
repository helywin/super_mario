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

func connect_signals():
	hit_animation.connect("animation_finished", self, "on_hit_animation_animation_finished")
	
func set_sprite():
		hittable_sprite.visible = can_hit
		unhittable_sprite.visible = !can_hit

# 需要重载
func on_hit():
	pass

func hit():
	if can_hit:
		on_hit()
		hit_audio.play()
		hit_animation.play("hit")
		return true
	else:
		unhit_audio.play()
		return false
		
func on_hit_animation_animation_finished(anime_name : String):
	set_sprite()
