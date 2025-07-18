class_name Spikes
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $HitboxComp/CollisionShape2D
@onready var raise_timer: Timer = $RaiseTimer
@onready var lower_timer: Timer = $LowerTimer


@export var raise_idle_time: float = 2
@export var lower_idle_time: float = 1

func _ready() -> void:
	raise_timer.timeout.connect(_raise_spikes)
	lower_timer.timeout.connect(_lower_spikes)
	
	raise_timer.start(raise_idle_time)

func _raise_spikes() -> void:
	animated_sprite_2d.play("default")
	await animated_sprite_2d.animation_finished
	collision_shape_2d.disabled = false
	lower_timer.start(lower_idle_time)


func _lower_spikes() -> void:
	animated_sprite_2d.play_backwards("default")
	await animated_sprite_2d.animation_finished
	collision_shape_2d.disabled = true
	raise_timer.start(raise_idle_time)
