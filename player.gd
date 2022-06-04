extends KinematicBody2D

onready var mario = $mario
onready var collison = $shape
export (float) var ACC_NORMAL = 3      # 非加速状态加速度
export (float) var ACC_AIR = 1.5      # 空中非加速状态加速度
export (float) var ACC_BOOST = 9     # 加速状态加速度
export (float) var ACC_SWIM = 0.05     # 游泳加速度
export (float) var MAX_X_SPEED_NORMAL = 180  # 陆地最大速度
export (float) var MAX_X_SPEED_BOOST = 8   # 加速状态陆地最大速度
export (float) var MAX_Y_SPEED_DYNAMIC = 16  # 陆地最大速度
export (float) var MAX_X_SPEED_SWIM_NORMAL = 1 # 游泳最大速度
export (float) var MAX_X_SPEED_SWIM_BOOST = 3  # 加速状态游泳最大速度
export (float) var MAX_Y_SPEED_SWIM_DYNAMIC = 6  # 陆地最大速度
export (float) var STOP_RATIO = 1.05            # 陆地每帧减速比值
export (float) var SWIM_STOP_RATIO = 1.03    # 游泳每帧减速比值
export (float) var JUMP_Y_SPEED = 180 # 陆地起跳初始速度
export (float) var JUMP_Y_SPEED_ON_WATER = 6 # 水面起跳初始速度
export (float) var JUMP_Y_SPEED_WATER = 4 # 水里起跳初始速度
export (float) var GRAVITY = 20 # 引力
export (float) var GRAVITY_SWIM = 0.2 # 游泳引力
export (float) var JUMP_ACC = 0.75 # 按住跳跃时持续提供的加速度
export (float) var JUMP_X_RATIO = 0.2 # 助跑系数
export (float) var JUMP_X_RATIO_SWIM = 0.1 # 游泳助跑系数

signal position_changed(position)
# 公式
# 纵向速度 = 动态速度 + 0.2 * 关卡引力值
# 起跳瞬间动态速度 = -(基础值+陆上绿果增益+横向速度增益系数*瞬间横向速度）

var jumping = false
# 人物的速度
var velocity = Vector2(0,0)


func _ready():
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
		velocity.y = -(JUMP_Y_SPEED + (JUMP_X_RATIO * abs(velocity.x)))
	if left:
		if is_on_floor():
			mario.scale = Vector2(-1, 1)
			velocity.x -= ACC_NORMAL
		else:
			velocity.x -= ACC_AIR


	if right:
		if is_on_floor():
			mario.scale = Vector2(1, 1)
			velocity.x += ACC_NORMAL
		else:
			velocity.x += ACC_AIR
	
	if is_on_floor() and abs(velocity.x) < ACC_NORMAL:
		velocity.x = 0
	elif not left and not right:
		velocity.x /= STOP_RATIO

	if jumping and jump and velocity.y < 0:
		velocity.y += GRAVITY * 0.25
	else:
		velocity.y += GRAVITY
	
	if jumping and not velocity.y < 0 and is_on_floor():
		mario.animation = "stand"
		jumping = false

	# 更新动作动画
	if is_on_floor() and (left or right):
		mario.animation = "walk"
	if mario.animation == "walk":
		mario.speed_scale = abs(velocity.x * 2.5 / MAX_X_SPEED_NORMAL)
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
	if is_on_floor() and abs(velocity.x) < ACC_NORMAL:
		mario.animation = "stand"
	if abs(velocity.x) > MAX_X_SPEED_NORMAL:
		velocity.x = sign(velocity.x) * MAX_X_SPEED_NORMAL
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# # 碰撞检测
	# for x in range(s.get_contact_count()):
	#     var ci = s.get_contact_local_normal(x)
	#     var pos = s.get_contact_local_position(x)
	#     if (ci == Vector2(0, -1)):
	#         print(pos)
	#         on_ground = true
	#         lv.y = 0
	#     elif (ci == Vector2(0, 1)):
	#         lv.y = -lv.y
	#         on_ground = true
	#     else:
	#         on_ground = true
			
	#     if (ci.x * lv.x < 0):
	#         lv.x = 0
	
	# # 处理按键事件
	# var acc_x = 0
	# var acc_y = 0
	# if on_ground:
	#     if jump:
	#         mario.animation = "jump"
	#         lv.y = -real_speed(JUMP_Y_SPEED) - JUMP_X_RATIO * abs(lv.x)
	#         on_ground = false
	#     elif move_left:
	#         mario.scale = Vector2(-1, 1)
	#         acc_x = -real_speed(ACC_NORMAL)
	#         mario.animation = "walk"
	#     elif move_right:
	#         acc_x = real_speed(ACC_NORMAL)
	#         mario.scale = Vector2(1, 1)
	#         mario.animation = "walk"
			
	# else: # 在空中
	#     if (jump && lv.y < 0):
	#         acc_y = real_speed(GRAVITY - JUMP_ACC)
	#     else:
	#         acc_y = real_speed(GRAVITY)
			
	# # 引入加速度
	# lv.x += acc_x
	# if (!move_left && !move_right):
	#     if (abs(lv.x) < real_speed(0.05)):
	#         lv.x = 0
	#     else:
	#         lv.x /= STOP_RATIO;
	
	# lv.y = lv.y +  acc_y + 0.2 * real_speed(GRAVITY)
	# if (abs(lv.x) > real_speed(MAX_X_SPEED_NORMAL)):
	#     lv.x = sign(lv.x) * real_speed(MAX_X_SPEED_NORMAL)
	# if (abs(lv.y) > real_speed(MAX_Y_SPEED_DYNAMIC)):
	#     lv.y = sign(lv.y) * real_speed(MAX_Y_SPEED_DYNAMIC)
	# if on_ground:
	#     if (move_right && lv.x < 0 || move_left && lv.x > 0):
	#         mario.animation = "stop"
	# if abs(lv.x) < real_speed(0.1):
	#     mario.animation = "stand"
	# s.set_linear_velocity(lv)
	emit_signal("position_changed", position)
	pass

