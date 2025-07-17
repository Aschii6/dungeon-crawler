class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 90.0

enum STATE {IDLE, WALK, SWORD_SWING, HURT}
var current_state: STATE = STATE.IDLE

var speed_debuff: float = 1 # Between 0 and 1

func _physics_process(delta: float) -> void:
	_process_movement()
	
	if Input.is_action_just_pressed("attack"):
		_launch_attack()

	move_and_slide()


func _process_movement() -> void:
	var horiz_direction = Input.get_axis("left", "right")
	var vert_direction = Input.get_axis("up", "down")
	
	var speed: float = SPEED * speed_debuff
	
	if horiz_direction and vert_direction:
		var new_velocity: Vector2 = speed * Vector2(horiz_direction, vert_direction).normalized()
		velocity = lerp(velocity, new_velocity, 0.3)
	elif horiz_direction:
		velocity.x = lerp(velocity.x, horiz_direction * speed, 0.3)
		velocity.y = lerp(velocity.y, 0.0, 0.45)
	elif vert_direction:
		velocity.y = lerp(velocity.y, vert_direction * speed, 0.3)
		velocity.x = lerp(velocity.x, 0.0, 0.45)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.45)
	
	if current_state != STATE.SWORD_SWING:
		if velocity.x < 0:
			animated_sprite_2d.flip_h = true
		elif velocity.x > 0:
			animated_sprite_2d.flip_h = false
	
	if current_state == STATE.IDLE and not velocity.is_zero_approx():
		current_state = STATE.WALK
		animated_sprite_2d.play("walk")
	if current_state == STATE.WALK and velocity.is_zero_approx():
		current_state = STATE.IDLE
		animated_sprite_2d.play("idle")

func _launch_attack() -> void:
	if current_state == STATE.SWORD_SWING:
		return
	
	current_state = STATE.SWORD_SWING
	speed_debuff = 0.8
	animated_sprite_2d.play("sword_swing")
	await animated_sprite_2d.animation_finished
	_finish_attack()
	#animated_sprite_2d.animation_finished.connect(_finish_attack)

func _finish_attack() -> void:
	speed_debuff = 1
	#animated_sprite_2d.animation_finished.disconnect(_finish_attack)
	if velocity.is_zero_approx():
		current_state = STATE.IDLE
		animated_sprite_2d.play("idle")
	else:
		current_state = STATE.WALK
		animated_sprite_2d.play("walk")
