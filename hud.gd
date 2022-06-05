extends Control

onready var time = $Time
onready var coin = $Coin
onready var score = $Score
onready var level = $World


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_time(v : int):
	var tmp = String(v)
	if (tmp.length() > 3):
		tmp = tmp.substr(tmp.length() - 3, 3)
	else:
		tmp = String("0").repeat(3 - tmp.length()) + tmp
		time.text = tmp
	pass

func set_coin(v : int):
	var tmp = String(v)
	tmp = String("0").repeat(2 - tmp.length()) + tmp
	coin.text = tmp

func set_score(v : int):
	var tmp = String(v)
	tmp = String("0").repeat(6 - tmp.length()) + tmp
	score.text = tmp

func set_level(l1 : int, l2: int):
	var tmp = String(l1) + "-" + String(l2)
	level.text = tmp
