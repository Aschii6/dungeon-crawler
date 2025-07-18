class_name Room
extends Node2D

@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3
@onready var tile_map_layer_4: TileMapLayer = $TileMapLayer4

@onready var top_door: Door = $TopDoor
@onready var left_door: Door = $LeftDoor
@onready var bottom_door: Door = $BottomDoor
@onready var right_door: Door = $RightDoor

@onready var top_door_collision_shape_2d: CollisionShape2D = $TopDoor/CollisionShape2D
@onready var left_door_collision_shape_2d: CollisionShape2D = $LeftDoor/CollisionShape2D
@onready var bottom_door_collision_shape_2d: CollisionShape2D = $BottomDoor/CollisionShape2D
@onready var right_door_collision_shape_2d: CollisionShape2D = $RightDoor/CollisionShape2D

# Walkable tiles (2,2) -> (15, 7)

var pos: Vector2i = Vector2i(0, 0)
var is_cleared: bool = true # Change base to false

func _ready() -> void:
	# Left wall
	tile_map_layer_2.set_cell(Vector2i(1, 4), 0, Vector2i(0, 3))
	tile_map_layer_2.set_cell(Vector2i(1, 5), 0, Vector2i(0, 3))
	
	# Right wall
	tile_map_layer_2.set_cell(Vector2i(16, 4), 0, Vector2i(5, 3))
	tile_map_layer_2.set_cell(Vector2i(16, 5), 0, Vector2i(5, 3))
	
	# Up wall
	tile_map_layer_2.set_cell(Vector2i(8, 1), 0, Vector2i(1, 0))
	tile_map_layer_2.set_cell(Vector2i(9, 1), 0, Vector2i(1, 0))
	
	# Down wall
	tile_map_layer_3.set_cell(Vector2i(8, 8), 0, Vector2i(1, 4))
	tile_map_layer_3.set_cell(Vector2i(9, 8), 0, Vector2i(1, 4))
	
	# Decorations 1
	tile_map_layer_4.set_cell(Vector2i(13, 6), 0, Vector2i(8, 6))
	tile_map_layer_4.set_cell(Vector2i(14, 6), 0, Vector2i(7, 7))
	tile_map_layer_4.set_cell(Vector2i(14, 5), 0, Vector2i(8, 6))
	
	# Decorations 2
	tile_map_layer_4.set_cell(Vector2i(3, 3), 0, Vector2i(8, 3))
	
	# Decorations 3
	tile_map_layer_4.set_cell(Vector2i(6, 1), 0, Vector2i(0, 9))
	var pos: Vector2 = tile_map_layer_4.map_to_local(Vector2i(6, 1))
	var point_light: PointLight2D = PointLight2D.new()
	point_light.texture = preload("res://assets/2d_lights_and_shadows_neutral_point_light.webp")
	point_light.position = pos
	point_light.texture_scale = 0.2
	add_child(point_light)
	
	tile_map_layer_4.set_cell(Vector2i(11, 1), 0, Vector2i(0, 9))
	pos = tile_map_layer_4.map_to_local(Vector2i(11, 1))
	point_light = PointLight2D.new()
	point_light.texture = preload("res://assets/2d_lights_and_shadows_neutral_point_light.webp")
	point_light.position = pos
	point_light.texture_scale = 0.2
	add_child(point_light)


func _process(delta: float) -> void:
	pass


## side: 0 - top, 1 - left, 2 - bottom, 3 - right
func add_door(side: int, room_leading_to: Room):
	var door: Door
	var pos_change: Vector2i
	if side == 0:
		door = top_door; pos_change = Vector2i.UP
		tile_map_layer_2.set_cell(Vector2i(8, 1), 0, Vector2i(6, 3))
		tile_map_layer_2.set_cell(Vector2i(9, 1), 0, Vector2i(7, 3))
	elif side == 1:
		door = left_door; pos_change = Vector2i.LEFT
		tile_map_layer_2.set_cell(Vector2i(1, 4), 0, Vector2i(8, 4))
		tile_map_layer_2.set_cell(Vector2i(1, 5), 0, Vector2i(8, 5))
	elif side == 2:
		door = bottom_door; pos_change = Vector2i.DOWN
		tile_map_layer_3.set_cell(Vector2i(8, 8), 0, Vector2i(6, 3))
		tile_map_layer_3.set_cell(Vector2i(9, 8), 0, Vector2i(7, 3))
	elif side == 3:
		door = right_door; pos_change = Vector2i.RIGHT
		tile_map_layer_2.set_cell(Vector2i(16, 4), 0, Vector2i(7, 4))
		tile_map_layer_2.set_cell(Vector2i(16, 5), 0, Vector2i(7, 5))
	
	door.room_inside = self
	door.side = side
	door.room_pos_leading_to = pos + pos_change
	door.enable()
