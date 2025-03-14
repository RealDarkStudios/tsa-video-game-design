extends Control
class_name FinishMenu

@export var game_manager: GameManager
@export var level_manager: LevelManager

@export var first_tex: TextureRect
@export var second_tex: TextureRect
@export var third_tex: TextureRect
@export var first_name: RichTextLabel
@export var second_name: RichTextLabel
@export var third_name: RichTextLabel

func _ready() -> void:
    pass
    
func show_rankings() -> void:
    var num = 2
    var texs: Array[TextureRect] = [first_tex, second_tex]
    var names: Array[RichTextLabel] = [first_name, second_name]
    
    if len(GlobalData.player_data) < 3:
        third_name.get_parent().get_parent().queue_free()
    else:
        num = 3
        texs.append(third_tex)
        names.append(third_name)
        
    for i in range(num):
        var player: PlayerData = level_manager.level_instance.rankings[i]
        var tex: TextureRect = texs[i]
        var name_label: RichTextLabel = names[i]
        
        tex.texture = player.player_type.texture
        name_label.text = player.player_name
        
    visible = true

func _on_next_level_pressed() -> void:
    for player in GlobalData.player_data:
        print("%s, %s, %s" % [player.player_id, player.player_name, player.score])

    level_manager.next_level()
    game_manager.reset()
    self.visible = false

func _on_quit_pressed() -> void:
    get_tree().change_scene_to_file("res://main_menu.tscn")
