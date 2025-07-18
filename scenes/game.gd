extends Node2D

const ROOM = preload("res://scenes/rooms/room.tscn")
const PLAYER = preload("res://scenes/player/player.tscn")

var rooms: Dictionary[Vector2i, Room]

var current_room: Room

var player: Player

var pos_changes: Array[Vector2i] = [Vector2i.UP, Vector2i.LEFT, 
		Vector2i.DOWN, Vector2i.RIGHT]

func _ready() -> void:
	var pos_stack: Array[Vector2i]
	var pos_list: Array[Vector2i]
	
	var starting_pos: Vector2i = Vector2i.ZERO
	pos_stack.push_back(starting_pos)
	pos_list.push_back(starting_pos)
	
	while not pos_stack.is_empty() and pos_list.size() < 12:
		var pos: Vector2i = pos_stack.pop_back()
		var min: int = 0; var max: int = 4
		if pos == Vector2i.ZERO: min = 2
		var num_neighb: int = randi_range(min, max)
		
		for i in range(num_neighb):
			var pos_change: Vector2i = pos_changes.pick_random()
			var new_room_pos: Vector2i = pos + pos_change
			if new_room_pos in pos_list: continue
			
			pos_list.push_back(new_room_pos)
			pos_stack.push_back(new_room_pos)
	
	for pos: Vector2i in pos_list:
		var room: Room = ROOM.instantiate()
		room.pos = pos
		rooms.set(pos, room)
	
	current_room = rooms.get(Vector2i.ZERO)
	add_child(current_room)
	for i in range (pos_changes.size()):
			var neighb_pos: Vector2i = current_room.pos + pos_changes[i]
			if rooms.has(neighb_pos):
				current_room.add_door(i, rooms.get(neighb_pos))
	
	player = PLAYER.instantiate()
	player.position = Vector2(100, 100)
	current_room.add_child(player)
	
	Events.room_change.connect(_on_room_change)

# A lot of redundant work
func _on_room_change(new_room_pos: Vector2i, side_entered: int):
	var new_room: Room = rooms.get(new_room_pos)
	
	var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2
	player.position = screen_center * 2 - player.position + Vector2(pos_changes[side_entered]) * 10
	
	current_room.remove_child(player)
	new_room.add_child(player)
	
	remove_child(current_room)
	add_child(new_room)
	current_room = new_room
	
	for i in range (pos_changes.size()):
			var neighb_pos: Vector2i = current_room.pos + pos_changes[i]
			if rooms.has(neighb_pos):
				current_room.add_door(i, rooms.get(neighb_pos))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
