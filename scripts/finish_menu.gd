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
@export var first_score: RichTextLabel
@export var second_score: RichTextLabel
@export var third_score: RichTextLabel

func _ready() -> void:
    pass

func show_rankings() -> void:
    var num = 2
    var texs: Array[TextureRect] = [first_tex, second_tex]
    var names: Array[RichTextLabel] = [first_name, second_name]
    var scores: Array[RichTextLabel] = [first_score, second_score]

    if len(GlobalData.player_data) < 3:
        if is_instance_valid(third_name):
            third_name.get_parent().get_parent().queue_free()
    else:
        num = 3
        texs.append(third_tex)
        names.append(third_name)
        scores.append(third_score)

    for i in range(num):
        var player: PlayerData = level_manager.level_instance.rankings[i]
        var tex: TextureRect = texs[i]
        var name_label: RichTextLabel = names[i]
        var score: RichTextLabel = scores[i]

        tex.texture = player.player_type.texture
        name_label.text = player.player_name
        score.text = "Total Score: %d" % (player.score)

    visible = true

func _on_next_level_pressed() -> void:
    level_manager.next_level()
    game_manager.reset()
    self.visible = false

func _on_quit_pressed() -> void:
    get_tree().change_scene_to_file("res://main_menu.tscn")
