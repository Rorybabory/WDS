extends Control

var button
var conveyor
var receptacle
var faster
var workerinst = preload("res://src/Instances/Worker.tscn")
var slotinst = preload("res://src/Instances/Slot.tscn")
var level
var placedSlots
func _ready():
	self.visible = false
	button = find_child("Worker")
	conveyor = find_child("Conveyor")
	receptacle = find_child("BoxReceptacle")
	faster = find_child("Faster")
	level = get_tree().get_root().get_child(0)
	placedSlots = 1
	button.pressed.connect(self.spawnWorker)
	conveyor.pressed.connect(self.giveConveyor)
	receptacle.pressed.connect(self.addSlot)
	faster.pressed.connect(self.makeFaster)
func makeFaster():
	if (level.money < 5):
		return
	level.money -= 5
	level.speed *= 2.0
func spawnWorker():
	if (level.money < 5):
		return
	level.money -= 5
	var scene_instance = workerinst.instantiate()
	get_tree().get_root().get_child(0).add_child(scene_instance)
	scene_instance.position.y = 1.0
	scene_instance.position.x = (randf()-0.5)*2.0*22.0
	scene_instance.position.z = (randf()-0.5)*2.0*22.0
	
func giveConveyor():
	if (level.money >= 1):
		level.conveyors+=4
		level.money-=1
func addSlot():
	var success = false
	var pos = 0.0
	pos = 22 - (placedSlots*2)
	if (level.money < 10):
		return
	level.money -= 10
	var scene_instance = slotinst.instantiate()
	scene_instance.position.y = 1.0
	scene_instance.position.x = -22.104
	scene_instance.position.z = pos
	get_tree().get_root().get_child(0).add_child(scene_instance)

	
	scene_instance.rotation.y = PI * 0.5
	placedSlots+=1
	

func _process(delta):
	if Input.is_action_just_pressed("ui_inventory"):
		self.visible = !self.visible
	
	
