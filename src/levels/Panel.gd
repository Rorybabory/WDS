extends Panel


func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://src/levels/test.tscn")
