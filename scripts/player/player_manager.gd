class_name PlayerManager
extends Node

@export var next_button: Button
@export var game_manager: GameManager

const player_scene: PackedScene = preload("res://player.tscn")
var players: Array[Node2D]

func _ready() -> void:
	setup_players()
	
func setup_players():
	next_button.disabled = false
	for player in GlobalData.player_data:
		var player_node = player_scene.instantiate()
		player_node.set_player_data(player)
		player_node.visible = false
		player_node.collider.disabled = true
		add_child(player_node)
		players.append(player_node)

func _process(_delta: float) -> void:
	pass
	
func check_button():
	# This is a really stupid way to do this
	# Bwut i dwon't cawe UwU
	for player in players:
		if player.frog_state == PlayerClass.FrogState.thrown:
			next_button.disabled = true
			return

	next_button.disabled = false
	
func set_state_all(player_state):
	for player in players:
		player.frog_state = player_state

func trigger_throw():
	next_button.disabled = true
	for player in players:
		player.throw_frog()
