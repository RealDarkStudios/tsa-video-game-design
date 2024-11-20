extends Control

func _on_play_pressed() -> void:
	#TODO: Go to game scene
	get_tree().change_scene_to_file("res://game.tscn")


func _on_settings_pressed() -> void:
	#TODO: Go to settings scene
	get_tree().change_scene_to_file("res://options.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
