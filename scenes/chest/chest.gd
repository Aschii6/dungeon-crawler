class_name Chest
extends Node2D

const HP_POT = preload("res://scenes/hp_pot/hp_pot.tscn")

@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $Control/Label

var near_chest: bool = false

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	near_chest = true
	label.text = "E to open"

func _on_area_exited(area):
	near_chest = false
	label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if near_chest and Input.is_action_just_pressed("interact"):
		Events.play_sfx.emit("res://assets/01_chest_open_1.wav")
		remove_child(area_2d)
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.0)
		await tween.finished
		var hp_pot: HpPot = HP_POT.instantiate()
		hp_pot.position = position
		get_parent().add_child(hp_pot)
		queue_free()
