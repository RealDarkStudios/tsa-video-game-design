extends Node
class_name LevelManager

@export var game_manager: GameManager
@export var levels: Array[String]

var level_instance: LevelBase
var current_level_number: int

func _ready() -> void:
    load_level(GlobalData.current_level)

func _process(_delta: float) -> void:
    pass

func unload_level():
    if (is_instance_valid(level_instance)):
        level_instance.queue_free()
    GlobalData.current_level = 0
    level_instance = null

func load_level(level_number: int):
    current_level_number = level_number
    GlobalData.current_level = level_number
    load_level_name(levels[level_number])
    
func load_level_name(level_name: String):
    unload_level()
    var level_path := "res://levels/%s.tscn" % level_name
    var level_resource := load(level_path)
    if (level_resource):
        level_instance = level_resource.instantiate()
        level_instance.finish_line.body_entered.connect(game_manager.on_finish)
        self.add_child(level_instance)

func next_level():
    if current_level_number + 1 >= len(levels):
        # This should be a finish screen
        get_tree().change_scene_to_file("res://ui_assests/final_podium.tscn")
        return

    load_level(current_level_number + 1)
