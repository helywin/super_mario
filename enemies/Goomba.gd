extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var VELOCITY_X = 20
export (Vector2) var velocity = Vector2(0,0)
var direction = -1
var dead = false
var initial_pos;

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	reset()
	pass # Replace with function body.

# 当玩家靠近才让怪动起来
func activate():
	pass
	
func die():
	if not dead:
		$CollisionPolygon2D.disabled = true
		dead = true
		$Sprite.animation = "dead"
		position.y += 4
		$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not dead:
		for i in get_slide_count():
			if is_on_wall():
				velocity.x = - direction * VELOCITY_X
				direction = -direction
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
