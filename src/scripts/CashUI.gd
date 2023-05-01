extends Label
var level
func _process(delta):
	if level == null:
		level = get_tree().get_root().get_child(0)
	self.text = "Balence: $" + str(level.money) + ""
