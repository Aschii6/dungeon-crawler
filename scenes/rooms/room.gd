class_name Room
extends Node2D

const SPIKES = preload("res://scenes/spikes/spikes.tscn")
const SKELETON = preload("res://scenes/enemies/skeleton.tscn")
const CHEST = preload("res://scenes/chest/chest.tscn")

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3
@onready var tile_map_layer_4: TileMapLayer = $TileMapLayer4

@onready var top_door: Door = $Doors/TopDoor
@onready var left_door: Door = $Doors/LeftDoor
@onready var bottom_door: Door = $Doors/BottomDoor
@onready var right_door: Door = $Doors/RightDoor

# Walkable tiles (2,2) -> (15, 7)

var pos: Vector2i = Vector2i(0, 0)
var is_cleared: bool = false

var enemies: Array[Enemy]

func _ready() -> void:
	pass

func spawn_enemies(num: int):
	var y_sort: Node = get_node("YSort")
	
	var tlm: TileMapLayer = get_node("TileMapLayer")
	for i in range(num):
		var enemy: Enemy = SKELETON.instantiate()
		var possible_pos: Array[Vector2] = [Vector2(14, 3), Vector2(13, 3), Vector2(3, 3), Vector2(4, 3), 
			Vector2(3, 6), Vector2(4, 6), Vector2(13, 6), Vector2(14, 6)]
			
		var pos: Vector2 = possible_pos.pick_random()
		possible_pos.erase(pos)
		
		enemy.position = tlm.map_to_local(pos)
		enemies.push_back(enemy)
		enemy.enemy_died.connect(_on_enemy_died.bind(enemy))
		y_sort.add_child(enemy)

func _on_enemy_died(enemy: Enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		is_cleared = true
		Events.room_cleared.emit()
		
		if (randf() < 0.5):
			spawn_chest()

func spawn_chest():
	var chest: Chest = CHEST.instantiate()
	chest.position = tile_map_layer.map_to_local(Vector2i(4, 4))
	call_deferred("add_chest", chest)

func add_chest(chest: Chest):
	var y_sort: Node = get_node("YSort")
	y_sort.add_child(chest)

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
	place_spikes()

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
			tml4.set_cell(Vector2i(4, 3), 0, Vector2i(8, 3))
			tml4.set_cell(Vector2i(13, 6), 0, Vector2i(8, 3))
			
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

func place_spikes():
	var rng: float = randf()
	if rng < 0.5: return
	var tml1: TileMapLayer = get_node("TileMapLayer")
	if rng < 0.75:
		for tml_pos: Vector2i in [Vector2i(8, 4), Vector2i(9, 4), Vector2i(8, 5), Vector2i(9, 5)]:
			var spikes: Spikes = SPIKES.instantiate()
			spikes.position = tml1.map_to_local(tml_pos)
			add_child(spikes)
	else:
		for tml_pos: Vector2i in [Vector2i(3, 3), Vector2i(3, 6), Vector2i(14, 3), Vector2i(14, 6)]:
			var spikes: Spikes = SPIKES.instantiate()
			spikes.position = tml1.map_to_local(tml_pos)
			add_child(spikes)

## side: 0 - top, 1 - left, 2 - bottom, 3 - right
func add_door(side: int, room_leading_to: Room):
	var tml2: Node = get_node("TileMapLayer2")
	var tml3: Node = get_node("TileMapLayer3")
	
	var door: Door
	if side == 0:
		door = get_node("Doors/TopDoor");
		tml2.set_cell(Vector2i(8, 1), 0, Vector2i(6, 3))
		tml2.set_cell(Vector2i(9, 1), 0, Vector2i(7, 3))
	elif side == 1:
		door = get_node("Doors/LeftDoor");
		tml2.set_cell(Vector2i(1, 4), 0, Vector2i(8, 4))
		tml2.set_cell(Vector2i(1, 5), 0, Vector2i(8, 5))
	elif side == 2:
		door = get_node("Doors/BottomDoor");
		tml3.set_cell(Vector2i(8, 8), 0, Vector2i(6, 3))
		tml3.set_cell(Vector2i(9, 8), 0, Vector2i(7, 3))
	elif side == 3:
		door = get_node("Doors/RightDoor");
		tml2.set_cell(Vector2i(16, 4), 0, Vector2i(7, 4))
		tml2.set_cell(Vector2i(16, 5), 0, Vector2i(7, 5))
	
	door.room_inside = self
	door.side = side
	door.room_leading_to = room_leading_to
	door.enable()


func change_label_text(new_text: String):
	var label: Label = get_node("Control/MarginContainer/Label")
	label.text = new_text


func add_player(player: Player):
	var y_sort: Node = get_node("YSort")
	y_sort.add_child(player)

func remove_player(player: Player):
	var y_sort: Node = get_node("YSort")
	y_sort.remove_child(player)
