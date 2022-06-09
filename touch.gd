extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$left.material.set_shader_param("darker", int(Input.is_action_pressed("move_left")) * 0.3)
	$right.material.set_shader_param("darker", int(Input.is_action_pressed("move_right")) * 0.3)
	$up.material.set_shader_param("darker", int(Input.is_action_pressed("move_up")) * 0.3)
	$down.material.set_shader_param("darker", int(Input.is_action_pressed("move_down")) * 0.3)
	$a.material.set_shader_param("darker", int(Input.is_action_pressed("jump")) * 0.3)
	$x.material.set_shader_param("darker", int(Input.is_action_pressed("boost")) * 0.3)
	$b.material.set_shader_param("darker", int(Input.is_action_pressed("fire")) * 0.3)
#	$left.material.set_shader_param("darker", int(Input.is_action_pressed("move_left")) * 0.5)
#	$left.material.set_shader_param("darker", int(Input.is_action_pressed("move_left")) * 0.5)


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
