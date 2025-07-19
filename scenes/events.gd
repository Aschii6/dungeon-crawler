extends Node


signal room_change(new_room: Room, side_entered: int)

signal player_hp_changed(new_value: int)

signal room_cleared()

signal heal_player(amount: int)
