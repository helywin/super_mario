extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = $Camera2D
onready var ui = $UI
onready var timer = $Timer
var start_time
var time_left

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_system_time_secs()
	timer.start(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_player_position_changed(pos : Vector2):
	camera.position.x = pos.x - 128
	ui.rect_position.x = pos.x - 128
	pass # Replace with function body.

onready var viewport = get_viewport()
	

func _screen_resized():
	var window_size = OS.get_window_size()

	# see how big the window is compared to the viewport size
	# floor it so we only get round numbers (0, 1, 2, 3 ...)
	var scale_x = floor(window_size.x / viewport.size.x)
	var scale_y = floor(window_size.y / viewport.size.y)

	# use the smaller scale with 1x minimum scale
	var scale = max(1, min(scale_x, scale_y))

	# find the coordinate we will use to center the viewport inside the window
	var diff = window_size - (viewport.size * scale)
	var diffhalf = (diff * 0.5).floor()

	# attach the viewport to the rect we calculated
	viewport.set_attach_to_screen_rect(Rect2(diffhalf, viewport.size * scale))


func _on_Timer_timeout():
	time_left = 360 - (OS.get_system_time_secs() - start_time)
	ui.set_time(time_left)
	pass # Replace with function body.
