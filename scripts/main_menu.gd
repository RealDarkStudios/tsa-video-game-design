extends Control

func _on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://setup_menu.tscn")

func _on_exit_pressed() -> void:
    get_tree().quit()


func _on_credits_pressed() -> void:
    $Credits.visible = true
