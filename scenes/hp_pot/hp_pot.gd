class_name HpPot
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $Control/Label

var heal_amount: int = 15
var near_pot: bool = false

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	near_pot = true
	label.text = "E to use"

func _on_area_exited(area):
	near_pot = false
	label.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if near_pot and Input.is_action_just_pressed("interact"):
		Events.heal_player.emit(heal_amount)
		Events.play_sfx.emit("res://assets/heal.wav")
		queue_free()
