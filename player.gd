extends RigidBody2D

onready var mario = $mario
onready var collison = $shape
const ACC_NORMAL = 0.1
const ACC_BOOST = 0.3
const ACC_SWIM = 0.05
const MAX_SPEED_NORMAL = 3
const MAX_SPEED_BOOST = 8
const MAX_SPEED_SWIM_NORMAL = 1
const MAX_SPEED_SWIM_BOOST = 3
const STOP_RATIO = 1.05
const SWIM_STOP_RATIO = 1.03
var on_ground = true


func _ready():
	pass # Replace with function body.



func real_speed(speed : float):
	return speed * 60

var flopping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
signal position_changed

func _integrate_forces(s : Physics2DDirectBodyState):
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var lv = s.get_linear_velocity()
	print(s.get_contact_count())
	var step = s.get_step()
	
	for x in range(s.get_contact_count()):
		print("collision")
		var ci = s.get_contact_local_normal(x)
		if (ci == Vector2(0, -1)):
			on_ground = true
			lv.y = 0
		elif (ci == Vector2(0, 1)):
			lv.y = -lv.y
		elif (ci.x * lv.x < 0):
			lv.x = 0
#		if ci.dot(Vector2(0, -1)) > 0.6:
#			
	if (jump && on_ground):
		lv.y = -100
		mario.animation = "jump"
		on_ground = false
	if (move_left && on_ground):
		mario.scale = Vector2(-1, 1)
		lv.x += -real_speed(ACC_NORMAL)
		mario.animation = "walk"
	if (move_right && on_ground):
		lv.x += real_speed(ACC_NORMAL)
		mario.scale = Vector2(1, 1)
		mario.animation = "walk"
	if (abs(lv.x) > real_speed(MAX_SPEED_NORMAL)):
		lv.x = sign(lv.x) * real_speed(MAX_SPEED_NORMAL)
	if (!move_left && !move_right):
		if (abs(lv.x) < real_speed(0.1)):
			lv.x = 0
		else:
			lv.x /= STOP_RATIO;
	if (move_right && lv.x < 0 ||
		move_left && lv.x > 0):
		mario.animation = "stop"
#	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	if abs(lv.x) < real_speed(0.1):
		mario.animation = "stand"
		
	emit_signal("position_changed", position)
	pass

