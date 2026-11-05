extends RigidBody2D




func _physics_process(delta: float) -> void:
	if position.y > 1280:
		get_parent().new_ball()
		queue_free()
