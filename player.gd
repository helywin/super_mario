extends KinematicBody2D

onready var mario = $mario
var collison
var jump_sound

export (float) var PHYSIC_ACC_NORMAL = 3      # 非加速状态加速度
export (float) var PHYSIC_ACC_AIR = 1.5      # 空中非加速状态加速度
export (float) var PHYSIC_ACC_BOOST = 9     # 加速状态加速度
export (float) var PHYSIC_ACC_SWIM = 0.05     # 游泳加速度
export (float) var PHYSIC_MAX_X_SPEED_NORMAL = 180  # 陆地最大速度
export (float) var PHYSIC_MAX_X_SPEED_BOOST = 8   # 加速状态陆地最大速度
export (float) var PHYSIC_MAX_Y_SPEED_NORMAL = 960  # 陆地最大速度
export (float) var PHYSIC_MAX_X_SPEED_SWIM_NORMAL = 1 # 游泳最大速度
export (float) var PHYSIC_MAX_X_SPEED_SWIM_BOOST = 3  # 加速状态游泳最大速度
export (float) var PHYSIC_MAX_Y_SPEED_SWIM_DYNAMIC = 6  # 陆地最大速度
export (float) var PHYSIC_STOP_RATIO = 1.05            # 陆地每帧减速比值
export (float) var PHYSIC_SWIM_STOP_RATIO = 1.03    # 游泳每帧减速比值
export (float) var PHYSIC_JUMP_Y_SPEED = 200 # 陆地起跳初始速度
export (float) var PHYSIC_HIT_ENEMIES_Y_SPEED = 180 # 踩到怪起跳速度
export (float) var PHYSIC_JUMP_Y_SPEED_ON_WATER = 6 # 水面起跳初始速度
export (float) var PHYSIC_JUMP_Y_SPEED_WATER = 4 # 水里起跳初始速度
export (float) var PHYSIC_GRAVITY = 20 # 引力
export (float) var PHYSIC_GRAVITY_SWIM = 0.2 # 游泳引力
export (float) var PHYSIC_JUMP_ACC = 0.75 # 按住跳跃时持续提供的加速度
export (float) var PHYSIC_JUMP_X_RATIO = 0.2 # 助跑系数
export (float) var PHYSIC_JUMP_X_RATIO_SWIM = 0.1 # 游泳助跑系数

export(int, "small", "big", "fire") var CHARACTOR_TYPE = 0

func _get_property_list():
	var properties = []
	properties.append({
			name = "Physic",
			type = TYPE_NIL,
			hint_string = "PHYSIC_",
			usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	return properties

signal position_changed(position)
signal add_coin(coin)
signal add_life(life)
signal dead_begin()
# 公式
# 纵向速度 = 动态速度 + 0.2 * 关卡引力值
# 起跳瞬间动态速度 = -(基础值+陆上绿果增益+横向速度增益系数*瞬间横向速度）

# 是否是跳跃中
var jumping = false
var jump_hold = false
# 人物的速度
export (Vector2) var velocity = Vector2(0,0)

var dead = false
var reborned = false
# 无敌闪烁次数
var invincible_count = 0
var direction = 1

func die():
	collison.disabled = true
	mario.animation = "die"
	$die.play()
	dead = true
	emit_signal("dead_begin")
	$dead_anime.play("die")
	
func reborn(var pos: Vector2):
	collison.disabled = false
	mario.animation = "stand"
	dead = false
	reborned = true
	position = pos
	mario.position = Vector2(0,0)
	velocity = Vector2(0,0)
	
func up():
	match CHARACTOR_TYPE:
		0:
			CHARACTOR_TYPE = 1
			collison = $collision_big
			jump_sound = $big_jump
			$collision_big.disabled = false
			$collision_big.visible = true
			$collision_small.disabled = true
			$collision_small.visible = false
			mario.play("0_to_1")
			position += Vector2(0, -8)
			Global.pause_enemies = true
			Global.pause_player = true
			$up.play()
		1:
			CHARACTOR_TYPE = 2
			mario.play("1_to_2")
			Global.pause_enemies = true
			Global.pause_player = true
			$up.play()
		2:	
			$up.play()
func down():
	match CHARACTOR_TYPE:
		0: die()
		1:
			CHARACTOR_TYPE = 0
			collison = $collision_small
			jump_sound = $small_jump
			$collision_big.disabled = true
			$collision_big.visible = false
			$collision_small.disabled = false
			$collision_small.visible = true
			mario.play("1_to_0")
			Global.pause_enemies = true
	#		Global.pause_bgm = true
			Global.pause_player = true
			$down.play()
			# 不能够和敌人发生碰撞
			set_collision_mask_bit(2, false)
			set_collision_layer_bit(1, false)
			set_collision_layer_bit(4, true)
			reborned = true
		2:
			CHARACTOR_TYPE = 0
			collison = $collision_small
			jump_sound = $small_jump
			$collision_big.disabled = true
			$collision_big.visible = false
			$collision_small.disabled = false
			$collision_small.visible = true
			mario.play("2_to_0")
			Global.pause_enemies = true
	#		Global.pause_bgm = true
			Global.pause_player = true
			$down.play()
			# 不能够和敌人发生碰撞
			set_collision_mask_bit(2, false)
			set_collision_layer_bit(1, false)
			set_collision_layer_bit(4, true)
			reborned = true
			

func life_inc():
	emit_signal("add_life", 1)

func _ready():
	match CHARACTOR_TYPE:
		0: 
			collison = $collision_small
			jump_sound = $small_jump
			$collision_big.disabled = true
		1,2:
			collison = $collision_big
			jump_sound = $big_jump
			$collision_small.disabled = true

var flopping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mario.scale.x = direction
	pass

func _physics_process(delta):
	if dead or Global.pause_player:
		return
	
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider;
#		print(collider.get_name())
		if is_on_ceiling():
			if collider.get_parent().get_name() == "CoinBricks":
				if collider.hit(CHARACTOR_TYPE):
					emit_signal("add_coin", 1)
			elif collider.get_parent().get_name() == "Bricks":
				collider.hit(CHARACTOR_TYPE)
				$bump.play()
			elif collider.get_parent().get_name() == "MushroomBricks":
				collider.hit(CHARACTOR_TYPE)
#		print(collider.get_name())
		if collider.get_name() == "Power":
			print("powerup")
			collider.hit()
			up()
		if collider.get_name() == "Life":
			print("life")
			collider.hit()
			life_inc()
		if not reborned and collider.get_parent().get_name() == "Enemies":
			var normal = get_slide_collision(i).normal
			if abs(normal.x) > abs(normal.y):
					down()
					return
			else:
				collider.die()
				$stomp.play()
				velocity.y = -PHYSIC_HIT_ENEMIES_Y_SPEED
	if position.y > 240:
		die()
		return
	if jump and is_on_floor():
		if not jump_hold:
			jump_hold = true
			jumping = true
			velocity.y = -(PHYSIC_JUMP_Y_SPEED + (PHYSIC_JUMP_X_RATIO * abs(velocity.x)))
			jump_sound.play()
	if not jump:
		jump_hold = false
	if not jumping and not is_on_floor() and jump:
		jump_hold = true
	if left:
		if is_on_floor():
			if direction != -1:
				direction = -1
			else:
				velocity.x -= PHYSIC_ACC_NORMAL
		else:
			velocity.x -= PHYSIC_ACC_AIR


	if right:
		if is_on_floor():
			if direction != 1:
				direction = 1
			else:
				velocity.x += PHYSIC_ACC_NORMAL
		else:
			velocity.x += PHYSIC_ACC_AIR
	
	if is_on_floor() and abs(velocity.x) < PHYSIC_ACC_NORMAL:
		velocity.x = 0
	elif is_on_floor() and ((velocity.x > 0 and left) or (velocity.x < 0 and right) or not(left or right)):
		if velocity.x >= 30:
			velocity.x /= PHYSIC_STOP_RATIO
		elif abs(velocity.x) < PHYSIC_ACC_NORMAL:
			velocity.x = 0
		else:
			velocity.x += - sign(velocity.x) * PHYSIC_ACC_NORMAL

	if jumping and jump and velocity.y < 0:
		velocity.y += PHYSIC_GRAVITY * 0.25
	else:
		velocity.y += PHYSIC_GRAVITY
	
	if not Global.pause_player:
		if jumping and not velocity.y < 0 and is_on_floor():
			mario.animation = "walk_" + String(CHARACTOR_TYPE)
			jumping = false

		# 更新动作动画
		if is_on_floor() and (left or right):
			mario.animation = "walk_" + String(CHARACTOR_TYPE)
		if mario.animation == "walk_" + String(CHARACTOR_TYPE):
			# 走路速度越快，动作越快，但是不能太慢
			mario.speed_scale = abs(velocity.x * 2.5 / PHYSIC_MAX_X_SPEED_NORMAL)
			if mario.speed_scale < 1:
				mario.speed_scale = 1
		if not is_on_floor() and not jumping:
			if mario.animation == "walk_" + String(CHARACTOR_TYPE):
				mario.speed_scale = 0
		if not is_on_floor() and jumping:
			mario.animation = "jump_" + String(CHARACTOR_TYPE)
		if is_on_floor():
			if right and velocity.x < 0 or left and velocity.x > 0:
				mario.animation = "stop_" + String(CHARACTOR_TYPE)
		if is_on_floor() and abs(velocity.x) < PHYSIC_ACC_NORMAL:
			mario.animation = "stand_" + String(CHARACTOR_TYPE)
	if abs(velocity.x) > PHYSIC_MAX_X_SPEED_NORMAL:
		velocity.x = sign(velocity.x) * PHYSIC_MAX_X_SPEED_NORMAL
	if abs(velocity.y) > PHYSIC_MAX_Y_SPEED_NORMAL:
		velocity.y = sign(velocity.y) * PHYSIC_MAX_Y_SPEED_NORMAL
	velocity = move_and_slide(velocity, Vector2(0, -1))
	emit_signal("position_changed", position)
	reborned = false
	pass
	


func _on_up_finished():
	print("up finished")
	Global.pause_enemies = false
	Global.pause_player = false


func _on_down_finished():
	print("up finished")
	Global.pause_enemies = false
	Global.pause_player = false
	if CHARACTOR_TYPE == 0:
		position += Vector2(0, 8)
	invincible_count = 0
	$invincible_timer.start()

func _on_invincible_timer_timeout():
	visible = !visible
	invincible_count +=1
	if invincible_count > 10:
		visible = true
		$invincible_timer.stop()
		# 能够和敌人发生碰撞
		set_collision_mask_bit(2, true)
		set_collision_layer_bit(1, true)
		set_collision_layer_bit(4, false)
	pass # Replace with function body.
