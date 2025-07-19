class_name HealthComp
extends Node

signal dead # Need?
signal hp_changed(new_value: int)

@export var hurtbox: HurtboxComp

@export var max_hp: int = 100
var current_hp: int

@export var invulnerability_period: float = 1
var invulnerable_countdown: float = 0

func _ready() -> void:
	current_hp = max_hp
	hurtbox.hurt.connect(_on_hurtbox_hurt)


func _on_hurtbox_hurt(hitbox: HitboxComp) -> void:
	if invulnerable_countdown > 0:
		return
	else:
		invulnerable_countdown = invulnerability_period
	
	#hitbox.hurtbox_hit.emit(hurtbox) # This instead of in Hurtbox? Maybe!
	
	current_hp -= hitbox.damage
	hp_changed.emit(current_hp)
	if current_hp <= 0:
		dead.emit()

func heal(heal_amount: int):
	current_hp = min(max_hp, current_hp + heal_amount)
	hp_changed.emit(current_hp)
	

func _process(delta: float) -> void:
	if invulnerable_countdown > 0:
		invulnerable_countdown -= delta
