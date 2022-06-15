extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_position_changed(pos : Vector2):
	for enemy in $Enemies.get_children():
		if enemy.position.x - pos.x < 128:
			enemy.activated = true
	pass
	
func reset():
	for child in $CoinBricks.get_children():
		child.reset()
	for child in $Enemies.get_children():
		child.reset()
