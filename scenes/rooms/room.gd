class_name Room
extends Node2D

@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3
@onready var tile_map_layer_4: TileMapLayer = $TileMapLayer4

@onready var top_door: Door = $Doors/TopDoor
@onready var left_door: Door = $Doors/LeftDoor
@onready var bottom_door: Door = $Doors/BottomDoor
@onready var right_door: Door = $Doors/RightDoor

# Walkable tiles (2,2) -> (15, 7)

var pos: Vector2i = Vector2i(0, 0)
var is_cleared: bool = true # Change base to false

func _ready() -> void:
	pass

func init() -> void:
	var tml2: Node = get_node("TileMapLayer2")
	var tml3: Node = get_node("TileMapLayer3")
	
	# Left wall
	tml2.set_cell(Vector2i(1, 4), 0, Vector2i(0, 3))
	tml2.set_cell(Vector2i(1, 5), 0, Vector2i(0, 3))
	# Right wall
	tml2.set_cell(Vector2i(16, 4), 0, Vector2i(5, 3))
	tml2.set_cell(Vector2i(16, 5), 0, Vector2i(5, 3))
	# Up wall
	tml2.set_cell(Vector2i(8, 1), 0, Vector2i(1, 0))
	tml2.set_cell(Vector2i(9, 1), 0, Vector2i(1, 0))
	# Down wall
	tml3.set_cell(Vector2i(8, 8), 0, Vector2i(1, 4))
	tml3.set_cell(Vector2i(9, 8), 0, Vector2i(1, 4))
	
	decorate(randi_range(1, 3))

func decorate(variation: int) -> void:
	var tml4: Node = get_node("TileMapLayer4")
	match variation:
		1:
			tml4.set_cell(Vector2i(13, 6), 0, Vector2i(8, 6))
			tml4.set_cell(Vector2i(14, 6), 0, Vector2i(7, 7))
			tml4.set_cell(Vector2i(14, 5), 0, Vector2i(8, 6))
			
			tml4.set_cell(Vector2i(3, 4), 0, Vector2i(8, 6))
			tml4.set_cell(Vector2i(3, 3), 0, Vector2i(7, 7))
			tml4.set_cell(Vector2i(4, 3), 0, Vector2i(8, 6))
		2:
			tml4.set_cell(Vector2i(3, 3), 0, Vector2i(8, 3))
			tml4.set_cell(Vector2i(14, 6), 0, Vector2i(8, 3))
			
			tml4.set_cell(Vector2i(3, 1), 0, Vector2i(4, 7))
			tml4.set_cell(Vector2i(14, 1), 0, Vector2i(4, 7))
		3:
			tml4.set_cell(Vector2i(6, 1), 0, Vector2i(0, 9))
			var pos: Vector2 = tml4.map_to_local(Vector2i(6, 1))
			var point_light: PointLight2D = PointLight2D.new()
			point_light.texture = preload("res://assets/2d_lights_and_shadows_neutral_point_light.webp")
			point_light.position = pos
			point_light.texture_scale = 0.2
			add_child(point_light)
			
			tml4.set_cell(Vector2i(11, 1), 0, Vector2i(0, 9))
			pos = tml4.map_to_local(Vector2i(11, 1))
			point_light = PointLight2D.new()
			point_light.texture = preload("res://assets/2d_lights_and_shadows_neutral_point_light.webp")
			point_light.position = pos
			point_light.texture_scale = 0.2
			add_child(point_light)


## side: 0 - top, 1 - left, 2 - bottom, 3 - right
func add_door(side: int, room_leading_to: Room):
	var tml2: Node = get_node("TileMapLayer2")
	var tml3: Node = get_node("TileMapLayer3")
	
	var door: Door
	var pos_change: Vector2i
	if side == 0:
		door = get_node("Doors/TopDoor"); pos_change = Vector2i.UP
		tml2.set_cell(Vector2i(8, 1), 0, Vector2i(6, 3))
		tml2.set_cell(Vector2i(9, 1), 0, Vector2i(7, 3))
	elif side == 1:
		door = get_node("Doors/LeftDoor"); pos_change = Vector2i.LEFT
		tml2.set_cell(Vector2i(1, 4), 0, Vector2i(8, 4))
		tml2.set_cell(Vector2i(1, 5), 0, Vector2i(8, 5))
	elif side == 2:
		door = get_node("Doors/BottomDoor"); pos_change = Vector2i.DOWN
		tml3.set_cell(Vector2i(8, 8), 0, Vector2i(6, 3))
		tml3.set_cell(Vector2i(9, 8), 0, Vector2i(7, 3))
	elif side == 3:
		door = get_node("Doors/RightDoor"); pos_change = Vector2i.RIGHT
		tml2.set_cell(Vector2i(16, 4), 0, Vector2i(7, 4))
		tml2.set_cell(Vector2i(16, 5), 0, Vector2i(7, 5))
	
	door.room_inside = self
	door.side = side
	door.room_leading_to = room_leading_to
	door.enable()
