extends Control



func _on_continue_pressed() -> void:
	$".".visible = false
	

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
