extends CharacterBody3D

var hasbox = false
var speed = 800
var boxstored
var boxinst = preload("res://src/Instances/box.tscn")
var level

var walksfx


func assignBox():
	boxstored = getNearestBox()

func _ready():
	walksfx = find_child("walksfx")
	speed += (randf()-0.5)*600


func getNearestBox() -> Node3D:
	var boxes = get_tree().get_root().get_child(0).find_child("Boxes").get_children()
	if (boxes.is_empty()):
		return null
	var nearest_box = boxes[0]
	
	for box in boxes:
		if box.global_position.distance_to(position) < nearest_box.global_position.distance_to(position) && box.global_position.y < 1.5:
			nearest_box = box
	if (randf() > 0.5):
		return nearest_box
	else:
		return boxes[randi() % boxes.size()]
	
	
	pass

func _physics_process(delta):
	velocity.y -= 5 * delta
	if (position.x > 24):
		position.x = 24
		return
	if (position.z > 24):
		position.z = 24
		return
	if (position.x < -24):
		position.x = -24
		return
	if (position.z < -24):
		position.z = -24
		return
	if (position.y < -24):
		position.y = 1
		return
	
	if (level == null):
		level = get_tree().get_root().get_child(0)
	if (hasbox == false):
		if (boxstored != null):
			velocity = Vector3()
			velocity = -self.get_global_transform().basis.z*delta*speed
			if (!walksfx.playing):
				walksfx.play()

			move_and_slide()
			look_at(boxstored.position)
#			self.rotation.y += sin(Time.get_ticks_msec()*0.004)*0.2
			self.rotation.x = 0
			self.rotation.z = 0
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if ("Box" in collision.get_collider().name):
					collision.get_collider().queue_free()
					find_child("box").position.y = 1.0
					hasbox = true
					find_child("pickupsfx").play()
					pass
		else:
			assignBox()
	else:
		var trucks = get_tree().get_root().get_child(0).find_children("Trucks")
		var nearestTruck = trucks[0]
		for truck in trucks:
			if truck.global_position.distance_to(position) < nearestTruck.global_position.distance_to(position):
				nearestTruck = truck
		var targetpos = nearestTruck.find_child("Target").global_position
		velocity = Vector3()
		velocity = -self.get_global_transform().basis.z*delta*speed
		if (!walksfx.playing):
			walksfx.play()

		move_and_slide()
		look_at(targetpos)
		#self.rotation.y += sin(Time.get_ticks_msec()*0.001)
		self.rotation.x = 0
		self.rotation.z = 0
		
		if (targetpos.distance_to(position) < 5.0):
			find_child("box").position.y = -2.5
			var scene_instance = boxinst.instantiate()
			get_tree().get_root().get_child(0).find_child("BoxesEnd").add_child(scene_instance)
			scene_instance.position.y = targetpos.y
			scene_instance.position.x = targetpos.x + (randf()-0.5)*3
			scene_instance.position.z = targetpos.z + (randf()-0.5)*3
			scene_instance.set_collision_mask(4)
			hasbox = false
			level.money -= 0.5
			find_child("placesfx").play()


