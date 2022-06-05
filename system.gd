extends Node


export (int) var PLAYER_LIFE = 3
export (int) var PLAYER_SCORE = 0
export (int) var PLAYER_COIN = 0
export (int) var PLAYER_TIME_REMAIN = 0
export (Vector2) var PLAYER_POSITION


signal coin_changed(coin)
signal score_changed(score)
signal life_changed(life)
signal time_remain_changed(time)
signal player_position_changed(pos)

onready var bgm = $Bgm

# Called when the node enters the scene tree for the first time.
func _ready():
	bgm.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_coin(var coin : int):
	PLAYER_COIN += coin
	if PLAYER_COIN >= 100:
		# TODO 播放音乐
		PLAYER_LIFE += PLAYER_COIN / 100
		PLAYER_COIN %= 100
		emit_signal("life_changed", PLAYER_LIFE)
	emit_signal("coin_changed", PLAYER_COIN)

func add_score(var score: int):
	PLAYER_SCORE += score
	emit_signal("score_changed", PLAYER_SCORE)

func set_time(var time : int):
	PLAYER_TIME_REMAIN = time
	emit_signal("time_remain_changed", PLAYER_TIME_REMAIN)

func set_player_position(var pos : Vector2):
	PLAYER_POSITION = pos
	# 音响跟着人走^v^
	self.position = pos
	emit_signal("player_position_changed", PLAYER_POSITION)
