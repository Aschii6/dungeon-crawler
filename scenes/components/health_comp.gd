class_name HealthComp
extends Node

signal dead # Need?
signal hp_changed(new_value: int)

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
	hp_changed.emit(hp)
	if hp <= 0:
		dead.emit()

func _process(delta: float) -> void:
	if invulnerable_countdown > 0:
		invulnerable_countdown -= delta
