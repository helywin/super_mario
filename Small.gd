extends Node2D

enum State {
	s_stand,
	s_walk,
	s_run,
	s_stop,
	s_jumping,
}

var state = State.s_stand

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var ch = get_node("mario")
	var jumpPressed = Input.is_action_pressed("ch_jump")
	var forwardPressed = Input.is_action_pressed("ch_forward")
	match (state):
		State.s_stand:
			if (jumpPressed):
				ch.animation = "jump"
			elif (forwardPressed):
				ch.animation = "walk"
			else:
				ch.animation = "stand"
		State.s_walk:
			if (jumpPressed):
				ch.animation = "jump"
			elif (forwardPressed):
				ch.animation = "walk"
			else:
				ch.animation = "stop"
		State.s_jumping:
			if (jumpPressed):
				ch.animation = "jump"
			elif (forwardPressed):
				ch.animation = "walk"
			else:
				ch.animation = "stop"
