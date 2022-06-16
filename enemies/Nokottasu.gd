extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var VELOCITY_X = 20
export (Vector2) var velocity = Vector2(0,0)
export (int) var ACC_Y = 14
var direction = -1
var dead = false
var initial_pos;
# 玩家靠近才能开始动
var activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	reset()
	pass # Replace with function body.
	
func die():
	if not dead:
		$CollisionPolygon2D.disabled = true
		dead = true
		$Sprite.animation = "dead"
		position.y += 4
		$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not activated or Global.pause_enemies:
		return
	if not dead:
		for i in get_slide_count():
			# 怪撞上玩家
			var collider = get_slide_collision(i).collider
			var dir = sign(get_slide_collision(i).get_position().x - position.x)
			if collider.name == "Player":
				collider.down()
			elif is_on_wall():
				direction = -dir
				velocity.x = direction * VELOCITY_X
				
		velocity.y += ACC_Y
		velocity = move_and_slide(velocity, Vector2(0, -1))

func reset():
	direction = -1
	position = initial_pos
	visible = true
	$CollisionPolygon2D.disabled = false
	$Sprite.animation = "walk"
	velocity.x = -VELOCITY_X
	dead = false

func _on_Timer_timeout():
	visible = false
	pass # Replace with function body.
