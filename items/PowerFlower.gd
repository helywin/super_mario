extends "res://items/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	collision = $CollisionShape2D
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit():
	activated = false
	visible = false
	collision.disabled = true

func _physics_process(delta):
	if not activated:
		return
	for i in get_slide_count():
		# 物体撞上玩家
		var collider = get_slide_collision(i).collider
		if collider.name == "Player":
			collider.up()
			hit()

func spawn():
	position += Vector2(0,-6)
	$Tween.interpolate_property(self, "position",
		self.position, self.position + Vector2(0, -10), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$spawn.play()
