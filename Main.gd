extends Node2D

onready var camera = $Camera2D
onready var hud = $HUD
onready var start = $Start
onready var timer = $Timer
onready var player = $Player
onready var system = $System
onready var gameover = $GameOver
onready var viewport = get_viewport()


# Called when the node enters the scene tree for the first time.
func _ready():
#	if OS.get_name() == "HTML5":
	timer.start(1)
	player.connect("position_changed", system, "set_player_position")
	player.connect("position_changed", $Level1, "on_player_position_changed")
	player.connect("add_coin", system, "add_coin")
	player.connect("dead_begin", system, "on_player_dead_begin")
	timer.connect("timeout", self, "_on_Timer_timeout")
	system.connect("time_remain_changed", hud, "set_time")
	system.connect("player_position_changed", self, "_on_player_position_changed")
	system.connect("coin_changed", hud, "set_coin")
	system.connect("coin_changed", start, "set_coin")
	system.connect("show_start_ui", start, "show")
	system.connect("close_start_ui", start, "hide")
	system.connect("show_gameover_ui", gameover, "show")
	system.connect("coin_changed", gameover, "set_coin")
#	system.connect("show_gameover_ui", start, "hide")
	system.connect("timeout_dead", player, "die")
	system.connect("reborn", player, "reborn")
	system.connect("reset_world", self, "on_reset_world")
	system.connect("life_changed", start, "set_life")


func _on_player_position_changed(pos : Vector2):
	camera.position.x = pos.x - 128
	hud.rect_position.x = pos.x - 128
	start.rect_position.x = pos.x - 128
	gameover.rect_position.x = pos.x - 128


	

func _screen_resized():
	var window_size = OS.get_window_size()
	print(window_size)
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

func on_reset_world():
	$Level1.reset()

func _process(delta):
	pass
