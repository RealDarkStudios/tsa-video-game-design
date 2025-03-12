extends Control
class_name SelectPlayerMenu

var selected_idx: int = 0
var players: Array[Node2D]

@export var playercardholder: HBoxContainer
@export var made_selection: Callable

const card = preload("res://ui_assests/select_card.tscn")

func show_players(players: Array[Node2D]):
    players = players
    
    for player in players:
        playercardholder.add_child(_add_player_card(player))
        
func _add_player_card(player: Node2D) -> Control:
    var new_idx = playercardholder.get_child_count()
    
    var select_card = card.instantiate();
    
    select_card.load_player_type(player.pdata.player_type)
    select_card.self_modulate = player.pdata.color
    select_card.player_name.text = player.pdata.player_name
    select_card.callback = _select_card(new_idx)
    
    return select_card
    
func _select_card(idx: int):
    selected_idx = idx
    
    for i in range(playercardholder.get_child_count()):
        if i == selected_idx:
             continue
        card.panel.self_modulate = players[i].pdata.color.darkened(0.5)
    
    var card = playercardholder.get_child(idx)
    card.panel.self_modulate = players[idx].pdata.color
    
    
func _on_confirm_pressed() -> void:
    made_selection.call(selected_idx)
