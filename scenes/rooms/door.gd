class_name Door
extends Area2D

var room_inside: Room
var side: int # 0 top, 1 left, 2 bottom, 3 right

var room_leading_to: Room

func _ready() -> void:
	pass

func enable() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not room_inside.is_cleared: return
	
	call_deferred("_emit_room_change")

func _emit_room_change():
	Events.room_change.emit(room_leading_to, side)
