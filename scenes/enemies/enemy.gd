class_name Enemy
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_comp: HitboxComp = $HitboxComp
@onready var hurtbox_comp: HurtboxComp = $HurtboxComp
@onready var health_comp: HealthComp = $HealthComp

var is_dead: bool = false

signal enemy_died

func _ready() -> void:
	health_comp.dead.connect(_on_dead)
	
	#health_comp.hp_changed.connect(_on_hp_changed)

# All inherited scenes must have this
func _on_dead():
	is_dead = true
	enemy_died.emit()
	remove_child(hitbox_comp)
	remove_child(hurtbox_comp)
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	var tween: Tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.0, 2.0).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()

#func _on_hp_changed(v: int):
	#var hurt_duration: float = health_comp.invulnerability_period
	#var tween: Tween = create_tween()
	#tween.tween_property(animated_sprite_2d, "modulate", Color(1.0, 0.7, 0.7), hurt_duration / 2)
	#await tween.finished
	#tween.tween_property(animated_sprite_2d, "modulate", Color(1.0, 1.0, 1.0), hurt_duration / 2)

func set_flip_v(flip: bool):
	animated_sprite_2d.flip_h = flip

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
