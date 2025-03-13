extends Node
class_name LevelManager

@export var game_manager: GameManager

var level_instance: LevelBase

func _ready() -> void:
    if (GlobalData.current_level != ""):
        load_level(GlobalData.current_level)

func _process(_delta: float) -> void:
    pass

func unload_level():
    if (is_instance_valid(level_instance)):
        level_instance.queue_free()
    GlobalData.current_level = ""
    level_instance = null
    
func load_level(level_name: String):
    unload_level()
    var level_path := "res://levels/%s.tscn" % level_name
    var level_resource := load(level_path)
    if (level_resource):
        level_instance = level_resource.instantiate()
        level_instance.finish_line.body_entered.connect(game_manager.on_finish)
        self.add_child(level_instance)
