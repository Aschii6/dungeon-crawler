class_name GameOverScreen
extends Control

func set_label_text(text: String):
	var label: Label = get_node("CenterContainer/Label")
	label.text = text
