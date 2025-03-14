extends Control
class_name FinalPodium

@export var first_tex: TextureRect
@export var second_tex: TextureRect
@export var third_tex: TextureRect
@export var first_name: Label
@export var second_name: Label
@export var third_name: Label
@export var first_score: RichTextLabel
@export var second_score: RichTextLabel
@export var third_score: RichTextLabel

func _ready() -> void:
    show_rankings()
    
func show_rankings() -> void:
    var num = 2
    var texs: Array[TextureRect] = [first_tex, second_tex]
    var names: Array[Label] = [first_name, second_name]
    var scores: Array[RichTextLabel] = [first_score, second_score]
    
    if len(GlobalData.player_data) < 3:
        if is_instance_valid(third_name):
            third_name.get_parent().get_parent().queue_free()
    else:
        num = 3
        texs.append(third_tex)
        names.append(third_name)
        scores.append(third_score)
        
    var final_rankings: Array[PlayerData] = GlobalData.player_data
        
    # I'm sure I (jonathan r morton) will reget doing this like this at some point (in the near future)
    var sorter = func(a: PlayerData, b: PlayerData): 
        return a.score > b.score

    final_rankings.sort_custom(sorter)
    final_rankings.resize(3)
        
    for i in range(num):
        var player = final_rankings[i]
        var tex: TextureRect = texs[i]
        var name_label: Label = names[i]
        var score: RichTextLabel = scores[i]
        
        tex.texture = player.player_type.texture
        name_label.text = player.player_name
        score.text = "Total Score: %d" % (player.score)

func _on_return_to_main_menu_button_pressed() -> void:
    get_tree().change_scene_to_file("res://main_menu.tscn")
