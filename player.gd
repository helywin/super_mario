extends RigidBody2D

enum State {
	s_stand,
	s_walk,
	s_run,
	s_stop,
	s_jumping,
}

onready var mario = $mario
onready var collison = $shape

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



var state = State.s_stand

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (state == State.s_walk):
		get_node("mario").get_node("body").constant_linear_velocity = Vector2(1,0)
	pass

#func _input(event):
#	var ch = get_node("mario")
#	var jumpPressed = Input.is_action_pressed("ch_jump")
#	var forwardPressed = Input.is_action_pressed("ch_forward")
#	match (state):
#		State.s_stand:
#			if (jumpPressed):
#				ch.animation = "jump"
#			elif (forwardPressed):
#				ch.animation = "walk"
#			else:
#				ch.animation = "stand"
#		State.s_walk:
#			if (jumpPressed):
#				ch.animation = "jump"
#			elif (forwardPressed):
#				ch.animation = "walk"
#			else:
#				ch.animation = "stop"
#		State.s_jumping:
#			if (jumpPressed):
#				ch.animation = "jump"
#			elif (forwardPressed):
#				ch.animation = "walk"
#			else:
#				ch.animation = "stop"
				
func _integrate_forces(s):
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	for x in range(s.get_contact_count()):
		print("collision")
#		var ci = s.get_contact_local_normal(x)
#		if ci.dot(Vector2(0, -1)) > 0.6:
#			
	if (jump):
		lv.y = -100
		mario.animation = "jump"
	if (move_left):
		mario.scale = Vector2(-1, 1)
		lv.x = -100
		mario.animation = "walk"
	if (move_right):
		lv.x = 100
		mario.scale = Vector2(1, 1)
		mario.animation = "walk"
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	if abs(lv.x) < 0.1:
		mario.animation = "stand"
	pass

	


func _on_player_body_entered(body):
	print("collision")
	pass # Replace with function body.
