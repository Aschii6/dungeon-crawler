class_name HealthComp
extends Node

signal dead

@export var hurtbox: HurtboxComp

@export var hp: int = 100

func _ready() -> void:
	hurtbox.hurt.connect(_on_hurtbox_hurt)


func _on_hurtbox_hurt(hitbox: HitboxComp) -> void:
	hp -= hitbox.damage
	if hp <= 0:
		dead.emit()
