extends RigidBody3D

var boxinst = preload("res://src/Instances/box.tscn")
var level

var placed

var despawntime

func _ready():
	despawntime = 0
	placed = false
	level = get_tree().get_root().get_child(0)

func _physics_process(delta):
	if (placed):
		despawntime+=delta
		if (despawntime > 10):
			self.queue_free()
		return
	var trucks = get_tree().get_root().get_child(0).find_children("Trucks");
	var nearestTruck = trucks[0]
	for truck in trucks:
		if truck.global_position.distance_to(position) < nearestTruck.global_position.distance_to(position):
			nearestTruck = truck
	var targetpos = nearestTruck.find_child("Target").global_position
	if (targetpos.distance_to(position) < 5.0):
		var scene_instance = boxinst.instantiate()
		if (self.get_parent().name != "BoxesEnd"):
			get_tree().get_root().get_child(0).find_child("BoxesEnd").add_child(self)
		position.y = targetpos.y
		position.x = targetpos.x + (randf()-0.5)
		position.z = targetpos.z + (randf()-0.5)
		set_collision_mask(4)
		level.money += 1.0
		placed = true
