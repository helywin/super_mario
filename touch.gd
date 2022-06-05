extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_up_pressed():
	Input.action_press("ui_up") 
	pass # Replace with function body.

func _on_up_released():
	Input.action_release("ui_up") 
	pass # Replace with function body.

func _on_left_pressed():
	Input.action_press("move_left")
	pass # Replace with function body.

func _on_left_released():
	Input.action_release("move_left")
	pass # Replace with function body.

func _on_right_pressed():
	Input.action_press("move_right")
	pass # Replace with function body.

func _on_right_released():
	Input.action_release("move_right")
	pass # Replace with function body.

func _on_a_pressed():
	Input.action_press("jump")
	pass # Replace with function body.

func _on_a_released():
	Input.action_release("jump")
	pass # Replace with function body.
