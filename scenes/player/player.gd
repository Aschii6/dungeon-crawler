class_name Player
extends CharacterBody2D


const SPEED = 90.0


func _physics_process(delta: float) -> void:
	var horiz_direction = Input.get_axis("left", "right")
	var vert_direction = Input.get_axis("up", "down")
	
	if horiz_direction and vert_direction:
		velocity = SPEED * Vector2(horiz_direction, vert_direction).normalized()
	elif horiz_direction:
		velocity.x = horiz_direction * SPEED
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif vert_direction:
		velocity.y = vert_direction * SPEED
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
