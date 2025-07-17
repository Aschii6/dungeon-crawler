class_name HitboxComp
extends Area2D

@export var damage: float = 1

signal hurtbox_hit(hurtbox: HurtboxComp)

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HurtboxComp: return
	
	var hurtbox: HurtboxComp = area
	hurtbox.hurt.emit(self)
	
	hurtbox_hit.emit(hurtbox)
