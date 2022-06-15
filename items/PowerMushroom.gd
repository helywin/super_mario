extends "res://items/Item.gd"

export (float) var ACC_Y = 10
export (bool) var REBOUND = false
export (Vector2) var INIT_VELOCITY = Vector2(100, 0)
var velocity = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	collision = $CollisionShape2D
	pass # Replace with function body.

func hit():
	activated = false
	visible = false
	collision.disabled = true

func _physics_process(delta):
	if not activated:
		return
	if is_on_floor() and REBOUND:
		velocity.y = -abs(velocity.y)
	if is_on_wall():
		velocity.x = -velocity.x
	velocity.y += ACC_Y
	for i in get_slide_count():
		# 物体撞上玩家
		var collider = get_slide_collision(i).collider
		if collider.name == "Player":
			collider.up()
			hit()
#	print("move and slide")
	move_and_slide(velocity, Vector2(0,-1))

func spawn():
	position += Vector2(0,-6)
	$Tween.interpolate_property(self, "position",
		self.position, self.position + Vector2(0, -10), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$spawn.play()

func _on_Tween_tween_all_completed():
#	print("tween finish")
	activated = true
	velocity = INIT_VELOCITY
