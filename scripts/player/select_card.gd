extends Node

@export var sprite: TextureRect
@export var player_name: RichTextLabel
@export var panel: Panel
@export var callback: Callable

var player_type: PlayerType

func load_player_type(new_player_type: PlayerType) -> void:
    player_type = new_player_type
    sprite.texture = new_player_type.texture

func _on_panel_gui_input(_event: InputEvent) -> void:
    callback.call()
