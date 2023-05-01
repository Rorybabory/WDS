extends Node3D
var boxinst = preload("res://src/Instances/box.tscn")
var count = 0
func _process(delta):
	count += delta
	if (count > 4.0):
		count = 0
		var scene_instance = boxinst.instantiate()
		get_tree().get_root().get_child(0).find_child("Boxes").add_child(scene_instance)
		scene_instance.position = self.get_global_transform().origin
