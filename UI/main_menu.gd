extends Control



func _on_play_pressed() -> void:
	GameManager.host_mode = true
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")


func _on_join_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
