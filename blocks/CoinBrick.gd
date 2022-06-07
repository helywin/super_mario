extends StaticBody2D

class_name CoinBrick

export (bool) var can_hit = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_texture()
	pass # Replace with function body.

func set_texture():
	$CoinBrick.visible = can_hit
	$Brick.visible = !can_hit

func hit():
	if can_hit:
		can_hit = false
		set_texture()
		$hit_coin.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

