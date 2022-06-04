extends KinematicBody2D

var mario
var collison

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
export (float) var PHYSIC_JUMP_Y_SPEED = 180 # 陆地起跳初始速度
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
# 公式
# 纵向速度 = 动态速度 + 0.2 * 关卡引力值
# 起跳瞬间动态速度 = -(基础值+陆上绿果增益+横向速度增益系数*瞬间横向速度）

# 是否是跳跃中
var jumping = false
# 人物的速度
var velocity = Vector2(0,0)

func is_dead():
	return false

func _ready():
	match CHARACTOR_TYPE:
		0: 
			mario = $mario_small
			collison = $collision_small
			$mario_big.visible = false
			$collision_big.disabled = true
		1:
			mario = $mario_big
			collison = $collision_big
			$mario_small.visible = false
			$collision_small.disabled = true
	pass # Replace with function body.

var flopping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")

	if jump and is_on_floor():
		jumping = true
		velocity.y = -(PHYSIC_JUMP_Y_SPEED + (PHYSIC_JUMP_X_RATIO * abs(velocity.x)))
	if left:
		if is_on_floor():
			if mario.scale.x != -1:
				mario.scale.x = -1
			else:
				velocity.x -= PHYSIC_ACC_NORMAL
		else:
			velocity.x -= PHYSIC_ACC_AIR


	if right:
		if is_on_floor():
			if mario.scale.x != 1:
				mario.scale.x = 1
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
	
	if jumping and not velocity.y < 0 and is_on_floor():
		mario.animation = "stand"
		jumping = false

	# 更新动作动画
	if is_on_floor() and (left or right):
		mario.animation = "walk"
	if mario.animation == "walk":
		# 走路速度越快，动作越快，但是不能太慢
		mario.speed_scale = abs(velocity.x * 2.5 / PHYSIC_MAX_X_SPEED_NORMAL)
		if mario.speed_scale < 1:
			mario.speed_scale = 1
	if not is_on_floor() and not jumping:
		if mario.animation == "walk":
			mario.speed_scale = 0
	if not is_on_floor() and jumping:
		mario.animation = "jump"
	if is_on_floor():
		if right and velocity.x < 0 or left and velocity.x > 0:
			mario.animation = "stop"
	if is_on_floor() and abs(velocity.x) < PHYSIC_ACC_NORMAL:
		mario.animation = "stand"
	if abs(velocity.x) > PHYSIC_MAX_X_SPEED_NORMAL:
		velocity.x = sign(velocity.x) * PHYSIC_MAX_X_SPEED_NORMAL
	if abs(velocity.y) > PHYSIC_MAX_Y_SPEED_NORMAL:
		velocity.y = sign(velocity.y) * PHYSIC_MAX_Y_SPEED_NORMAL
	velocity = move_and_slide(velocity, Vector2(0, -1))
	emit_signal("position_changed", position)
	pass

