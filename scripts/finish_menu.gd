extends Control
class_name FinishMenu

@export var game_manager: GameManager
@export var level_manager: LevelManager

func _ready() -> void:
    pass

func _on_next_level_pressed() -> void:
    for player in GlobalData.player_data:
        print("%s, %s, %s" % [player.player_id, player.player_name, player.score])

    level_manager.next_level()
    game_manager.reset()
    self.visible = false

func _on_quit_pressed() -> void:
    get_tree().change_scene_to_file("res://main_menu.tscn")
