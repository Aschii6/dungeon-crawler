class_name Door
extends Area2D

var room_inside: Room
var side: int # 0 top, 1 left, 2 bottom, 3 right

var room_pos_leading_to: Vector2i

func _ready() -> void:
	pass

func enable() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not room_inside.is_cleared: return
	
	
