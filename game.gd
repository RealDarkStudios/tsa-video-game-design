extends Node2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		$PauseMenu.visible = true
		get_tree().paused = true
