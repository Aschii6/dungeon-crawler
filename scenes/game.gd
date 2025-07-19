extends Node2D

const ROOM = preload("res://scenes/rooms/room.tscn")
const PLAYER = preload("res://scenes/player/player.tscn")
const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")

@onready var texture_progress_bar: TextureProgressBar = $Control/MarginContainer/TextureProgressBar
@onready var label: Label = $Control/Label

@onready var asp: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var asp2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

var rooms: Dictionary[Vector2i, Room]
var num_rooms_cleared: int = 1

var current_room: Room
var player: Player

var pos_changes: Array[Vector2i] = [Vector2i.UP, Vector2i.LEFT, 
		Vector2i.DOWN, Vector2i.RIGHT]

func _ready() -> void:
	asp.play()
	asp.finished.connect(func(): asp.play())
	
	Events.play_sfx.connect(func(path: String):
		asp2.stream = load(path)
		asp2.play()
	)
	
	var pos_stack: Array[Vector2i]
	var pos_list: Array[Vector2i]
	
	var starting_pos: Vector2i = Vector2i.ZERO
	pos_stack.push_back(starting_pos)
	pos_list.push_back(starting_pos)
	
	while not pos_stack.is_empty() and pos_list.size() < 7:
		var pos: Vector2i = pos_stack.pop_back()
		var min: int = 1; var max: int = 4
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
		room.init()
		room.pos = pos
		rooms.set(pos, room)
		if pos != Vector2i.ZERO:
			room.spawn_enemies(randi_range(2, 5))
	
	for room: Room in rooms.values():
		for i in range (pos_changes.size()):
				var neighb_pos: Vector2i = room.pos + pos_changes[i]
				if rooms.has(neighb_pos):
					room.add_door(i, rooms.get(neighb_pos))
	
	player = PLAYER.instantiate()
	player.position = Vector2(100, 100)
	current_room = rooms.get(Vector2i.ZERO)
	current_room.is_cleared = true
	current_room.add_player(player)
	current_room.change_label_text("WASD - move\nSPACE - attack")
	add_child(current_room)
	
	Events.room_change.connect(_on_room_change)
	Events.player_hp_changed.connect(
		func(new_value: int): 
			texture_progress_bar.value = new_value
			if new_value <= 0:
				call_deferred("change_to_game_over", "Game Over")
	)
	
	Events.room_cleared.connect(_on_room_cleared)

func change_to_game_over(text: String):
	var gos: GameOverScreen = GAME_OVER_SCREEN.instantiate()
	gos.set_label_text(text)
	
	var temp_scene: PackedScene = PackedScene.new()
	temp_scene.pack(gos)
	get_tree().change_scene_to_packed(temp_scene)
	

func _on_room_change(new_room: Room, side_entered: int):
	var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2
	player.position = screen_center * 2 - player.position + Vector2(pos_changes[side_entered]) * 8
	
	current_room.remove_player(player)
	new_room.add_player(player)
	
	remove_child(current_room)
	add_child(new_room)
	current_room = new_room


func _on_room_cleared():
	label.text = "Room Cleared"
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1.5)
	await timer.timeout
	remove_child(timer)
	label.text = ""
	
	num_rooms_cleared += 1
	if num_rooms_cleared == rooms.size():
		label.text = "All Rooms Cleared"
		timer = Timer.new()
		add_child(timer)
		timer.start(1.5)
		await timer.timeout
		call_deferred("change_to_game_over", "You Won")


func _physics_process(delta: float) -> void:
	for enemy: Enemy in current_room.enemies:
		if enemy.is_dead: continue
		
		var direction: Vector2 = (player.position - enemy.position).normalized()
		if direction.x < 0: enemy.set_flip_v(true)
		else: enemy.set_flip_v(false)
		
		enemy.position += direction * 20 * delta
