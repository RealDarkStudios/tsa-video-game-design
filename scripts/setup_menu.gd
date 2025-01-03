extends Control

@export var player_card_holder: Node
@export var player_card_add: Button
@export var player_card_remove: Button

var player_card = preload("res://ui_assests/player_card.tscn")

func _ready() -> void:
	add_player_card()
	add_player_card()
	
	player_card_remove.disabled = true
	player_card_add.disabled = false

func add_player_card() -> void:
	var new_carditgogooodtplayer_card.instantiate();
	player_card_holder.add_child(new_card)
	
	player_card_remove.disabled = false
	
	if player_card_holder.get_child_count() >= 4:
		player_card_add.disabled = true
		

func remove_player_card() -> void:
	player_card_holder.remove_child(
		player_card_holder.get_child(player_card_holder.get_child_count()-1))
	
	player_card_add.disabled = false
	
	if player_card_holder.get_child_count() <= 2:
		player_card_remove.disabled = true

func _on_add_player_pressed() -> void:
	add_player_card()
	
func _on_remove_player_pressed() -> void:
	remove_player_card()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
