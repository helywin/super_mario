extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var ch = get_node("charactor")
	if Input.is_action_pressed("ch_forward"):
		ch.animation = "walk"
	elif Input.is_action_pressed("ch_jump"):
		ch.animation = "jump"
#	elif Input.is_action_just_released("ch_forward"):
#		ch.animation = "stop"
	else:
		ch.animation = "stand"
