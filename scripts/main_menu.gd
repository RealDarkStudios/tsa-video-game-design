extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://setup_menu.tscn")


func _on_settings_pressed() -> void:
	#TODO: Go to settings scene
	get_tree().change_scene_to_file("res://options.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
