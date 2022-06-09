extends StaticBody2D

export (bool) var can_hit = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_texture()
	pass # Replace with function body.

func set_texture():
	$Origin/CoinBrick.visible = can_hit
	$Origin/Brick.visible = !can_hit

func hit():
	if can_hit:
		can_hit = false
		$hit_coin.play()
		$anime.play("hit")
		print($anime.current_animation)
		return true
	return false

func _on_anime_animation_finished(anime_name : String):
	set_texture()
	
func _process(delta):
	pass

func reset():
	can_hit = true
	set_texture()
	

