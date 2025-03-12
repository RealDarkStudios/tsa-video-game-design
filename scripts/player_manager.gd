class_name PlayerManager
extends Node


var player_scene: PackedScene = preload("res://player.tscn")
var players: Array[Node2D]

func _ready() -> void:
    for player in GlobalData.player_data:
        var player_node = player_scene.instantiate()
        player_node.set_player_data(player)

        add_child(player_node)
        players.append(player_node)

func _process(delta: float) -> void:
    pass
    
func set_state(player_state):
    for player in players:
        player.FrogCurrentState = player_state

func trigger_throw():
    for player in players:
        player.throw_frog()
