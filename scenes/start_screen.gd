extends Control

@onready var button: Button = $CenterContainer/VBoxContainer/Button

const GAME = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(func(): get_tree().change_scene_to_packed(GAME))
