extends Node
class_name PowerupManager

@export var powerup_types: Array[Powerup]
var currently_using: Dictionary

func _ready() -> void:
    pass
    
func register_for_use(plr: PlayerClass, data: PowerupData):
    currently_using.get_or_add(plr, data)
    
func use_all():
    currently_using.clear()

    
func random() -> Powerup:
    return powerup_types.pick_random()
