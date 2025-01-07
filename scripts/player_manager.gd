extends Node

@export var camera: PhantomCamera2D

var player_scene: PackedScene = preload("res://player.tscn")

func _ready() -> void:
	for player in GlobalData.player_data:
		var player_node = player_scene.instantiate()
		player_node.set_player_type(player.player_type)
		add_child(player_node)

func _process(delta: float) -> void:
	pass

func trigger_throw():
	var players: Array[Node2D]
	players.assign(get_children())
	
	camera.follow_targets.clear()
	camera.append_follow_targets_array(players)
	
	for player in players:
		player.throw_frog()
