extends Control

@export var player_card_holder: Node
@export var player_card_add: Button
@export var player_card_remove: Button

const player_card = preload("res://ui_assests/player_card.tscn")

func _ready() -> void:
    add_player_card()
    add_player_card()
    
    player_card_remove.disabled = true
    player_card_add.disabled = false

func add_player_card() -> void:
    var new_card = player_card.instantiate();
    
    new_card.player_name.text = \
        "Player %d" % (player_card_holder.get_child_count() + 1)

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
    var players = player_card_holder.get_children()

    for player in players:
        var data = PlayerData.new()
        data.player_name = player.player_name.text
        data.player_type = player.player_type
        GlobalData.player_data.append(data)

    get_tree().change_scene_to_file("res://game.tscn")
