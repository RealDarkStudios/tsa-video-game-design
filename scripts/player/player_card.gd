extends Node

@export var sprite: TextureRect
@export var jump_bar: ProgressBar
@export var speed_bar: ProgressBar
@export var player_name: LineEdit

var player_type: PlayerType
var current_type_index: int = 0

@export var player_types: Array[PlayerType]

func _ready() -> void:
    load_player_type(player_types[current_type_index])

func load_player_type(new_player_type: PlayerType) -> void:
    player_type = new_player_type
    jump_bar.value = new_player_type.jump_power
    speed_bar.value = new_player_type.speed
    sprite.texture = new_player_type.texture
    sprite.modulate = new_player_type.tint

func _on_left_pressed() -> void:
    current_type_index = wrapi(current_type_index - 1, 0, player_types.size())
    load_player_type(player_types[current_type_index])

func _on_right_pressed() -> void:
    current_type_index = wrapi(current_type_index + 1, 0, player_types.size())
    load_player_type(player_types[current_type_index])
