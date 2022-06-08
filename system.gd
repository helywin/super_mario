extends Node


export (int) var PLAYER_LIFE = 3
export (int) var PLAYER_SCORE = 0
export (int) var PLAYER_COIN = 0
export (Vector2) var PLAYER_POSITION
const PLAYER_START_POS = Vector2(136,200)
const LEVEL_SECONDS = 360


signal coin_changed(coin)
signal score_changed(score)
signal life_changed(life)
signal time_remain_changed(time)
signal player_position_changed(pos)

onready var bgm = $Bgm

signal show_ui()
signal close_ui()
signal timeout_dead()
signal reborn(pos)

var time_left
var start_time

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_system_time_secs()
	$Timer.start()
	bgm.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_coin(var coin : int):
	PLAYER_COIN += coin
	if PLAYER_COIN >= 100:
		$add_life.play()
		PLAYER_LIFE += PLAYER_COIN / 100
		PLAYER_COIN %= 100
		emit_signal("life_changed", PLAYER_LIFE)
	emit_signal("coin_changed", PLAYER_COIN)

func add_score(var score: int):
	PLAYER_SCORE += score
	emit_signal("score_changed", PLAYER_SCORE)

func set_player_position(var pos : Vector2):
	PLAYER_POSITION = pos
	# 音响跟着人走^v^
	self.position = pos
	emit_signal("player_position_changed", PLAYER_POSITION)
	
func on_player_dead_begin():
	$Timer.stop()
	bgm.stop()
	$DeadTimer.start()


func _on_DeadTimer_timeout():
	$RebornTimer.start()
	emit_signal("show_ui")
	pass # Replace with function body.


func _on_RebornTimer_timeout():
	$Timer.start()
	start_time = OS.get_system_time_secs()
	$Bgm.play()
	emit_signal("close_ui")
	emit_signal("reborn", PLAYER_START_POS)
	pass # Replace with function body.


func _on_Timer_timeout():
	time_left = LEVEL_SECONDS - (OS.get_system_time_secs() - start_time)
	if time_left <= 0:
		emit_signal("timeout_dead")
		emit_signal("time_remain_changed", 0)
	else:
		emit_signal("time_remain_changed", time_left)
	pass # Replace with function body.
