extends Node

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.visible = false
