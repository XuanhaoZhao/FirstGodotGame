extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
# roll
const ROLL_SPEED = 300.0  # 翻滚速度
const ROLL_DURATION = 0.5
# roll
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var inv_timer: Timer = $InvincibleTimer

var is_rolling = false
var is_invincible = false

# var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("roll") and not is_rolling:
		start_roll()
	
	var direction := Input.get_axis("move_left", "move_right")
	# print(direction)
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		animated_sprite.play("Jump")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#if not is_rolling:
		#var direction := Input.get_axis("move_left", "move_right")
		#if direction > 0:
			#animated_sprite.flip_h = false
		#if direction < 0:
			#animated_sprite.flip_h = true
#
		#if is_on_floor():
			#if direction == 0:
				#animated_sprite.play("Idle")
			#else:
				#animated_sprite.play("Run")
		#else:
			#animated_sprite.play("Jump")
#
		#if direction:
			#velocity.x = direction * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
	#else:
		## 翻滚中朝固定方向移动
		#if animated_sprite.flip_h:
			#velocity.x = -ROLL_SPEED
		#else:
			#velocity.x = ROLL_SPEED

	move_and_slide()



func start_roll():
	is_rolling = true
	is_invincible = true
	animated_sprite.play("roll")
	inv_timer.start(ROLL_DURATION)
	print("翻滚中，无敌开始")


func _on_invincible_timer_timeout() -> void:
	is_rolling = false
	is_invincible = false
	print("翻滚结束，无敌结束")
