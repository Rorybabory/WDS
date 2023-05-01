extends Camera3D

var maxspeed = 10

var speed = Vector3(0, 0, 0)

var rayOrigin = Vector3()
var rayEnd = Vector3()
var conveyorinst = preload("res://src/Instances/conveyor.tscn")
var cornerinst = preload("res://src/Instances/conveyorcorner.tscn")
var boxinst = preload("res://src/Instances/box.tscn")

var UI

var level

func _ready():
	UI = get_node("../Control")
	level = get_tree().get_root().get_child(0)

func _physics_process(delta):
	speed.x = lerp(speed.x, Input.get_axis("ui_left", "ui_right")*maxspeed, 0.1)
	speed.z = lerp(speed.z, Input.get_axis("ui_up", "ui_down")*maxspeed, 0.1)
	
	position.x += speed.x * delta;
	position.z += speed.z * delta;
	
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	rayOrigin = project_ray_origin(mouse_position)
	rayEnd = rayOrigin + project_ray_normal(mouse_position) * 2000
	var params = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = space_state.intersect_ray(params)
	
	var arrow = get_node("../Arrow")
	
	if (UI.visible):
		return
	
	if intersection:
		var pos = intersection.position
		var iname = intersection.collider.name
		arrow.position.x = snapped(pos.x, 2)
		arrow.position.z = snapped(pos.z, 2)
		if (level.conveyors < 1):
			arrow.position.y = -5
		else:
			arrow.position.y = 0.519
		if Input.is_action_just_pressed("ui_delete") && ("Box" in iname || "Conveyor" in iname):
			intersection.collider.queue_free()
		if Input.is_action_just_pressed("ui_select") && iname == "Floor":
			if (level.conveyors <= 0):
				return
			level.conveyors-=1
			var scene_instance = conveyorinst.instantiate()
			get_tree().get_root().get_child(0).add_child(scene_instance)
			scene_instance.position.y = pos.y
			scene_instance.position.x = snapped(pos.x, 2)
			scene_instance.position.z = snapped(pos.z, 2)
			scene_instance.rotation.y = arrow.rotation.y
		if Input.is_action_just_pressed("ui_select3") && iname == "Floor":
			var scene_instance = cornerinst.instantiate()
			get_tree().get_root().get_child(0).add_child(scene_instance)
			scene_instance.position.y = pos.y
			scene_instance.position.x = snapped(pos.x, 2)
			scene_instance.position.z = snapped(pos.z, 2)
			scene_instance.rotation.y = arrow.rotation.y
		if Input.is_action_just_pressed("ui_select2"):
			arrow.rotation.y -= PI/2.0
		if Input.is_action_just_pressed("spawnbox") && "Conveyor" in iname:
			var scene_instance = boxinst.instantiate()
			get_tree().get_root().get_child(0).add_child(scene_instance)
			scene_instance.position.y = pos.y + 3.0
			scene_instance.position.x = snapped(pos.x, 2)
			scene_instance.position.z = snapped(pos.z, 2)
			
		
		
		

