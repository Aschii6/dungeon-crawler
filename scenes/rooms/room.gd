extends Node2D

@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3
@onready var tile_map_layer_4: TileMapLayer = $TileMapLayer4

func _ready() -> void:
	# Left door
	tile_map_layer_2.set_cell(Vector2i(1, 4), 0, Vector2i(8, 4))
	tile_map_layer_2.set_cell(Vector2i(1, 5), 0, Vector2i(8, 5))
	
	# Right door
	tile_map_layer_2.set_cell(Vector2i(16, 4), 0, Vector2i(7, 4))
	tile_map_layer_2.set_cell(Vector2i(16, 5), 0, Vector2i(7, 5))
	
	# Up door
	tile_map_layer_2.set_cell(Vector2i(8, 1), 0, Vector2i(6, 3))
	tile_map_layer_2.set_cell(Vector2i(9, 1), 0, Vector2i(7, 3))
	
	# Down door
	tile_map_layer_3.set_cell(Vector2i(8, 8), 0, Vector2i(6, 3))
	tile_map_layer_3.set_cell(Vector2i(9, 8), 0, Vector2i(7, 3))
	
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
