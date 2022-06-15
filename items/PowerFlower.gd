extends "res://items/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	collision = $CollisionShape2D
	pass # Replace with function body.

func on_collide_player(player):
	player.up()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
