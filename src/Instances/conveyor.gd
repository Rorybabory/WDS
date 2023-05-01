extends StaticBody3D

var level
func _ready():
	level = get_tree().get_root().get_child(0)
func _process(delta):
	if (!$AudioStreamPlayer3D.playing):
		$AudioStreamPlayer3D.play()
	constant_linear_velocity.x = -level.speed * sin(rotation.y)
	constant_linear_velocity.z = -level.speed * cos(rotation.y)
