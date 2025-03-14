extends Node
class_name PowerupManager

@export var powerup_types: Array[Powerup]

func _ready() -> void:
	pass

func random() -> Powerup:
	return powerup_types.pick_random()
