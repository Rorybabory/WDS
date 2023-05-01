extends CharacterBody3D

var gravity = 10.0
var speed = 8.0

func _physics_process(delta):
	velocity.y -= gravity * delta

	velocity.x = Input.get_axis("ui_left", "ui_right") * speed
	velocity.z = Input.get_axis("ui_up", "ui_down") * speed
	move_and_slide()
