extends MeshInstance3D

var mat = get_active_material(0)
var speed = 0.2

func _process(delta):
	mat.uv1_offset.x += delta*speed
