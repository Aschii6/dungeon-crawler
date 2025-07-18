class_name HealthComp
extends Node

signal dead

@export var hurtbox: HurtboxComp

@export var hp: int = 100

@export var invulnerability_period: float = 1
var invulnerable_countdown: float = 0

func _ready() -> void:
	hurtbox.hurt.connect(_on_hurtbox_hurt)


func _on_hurtbox_hurt(hitbox: HitboxComp) -> void:
	if invulnerable_countdown > 0:
		return
	else:
		invulnerable_countdown = invulnerability_period
	
	#hitbox.hurtbox_hit.emit(hurtbox) # This instead of in Hurtbox? Maybe!
	
	hp -= hitbox.damage
	if hp <= 0:
		dead.emit()
	print_debug(hp)

func _process(delta: float) -> void:
	if invulnerable_countdown > 0:
		invulnerable_countdown -= delta
