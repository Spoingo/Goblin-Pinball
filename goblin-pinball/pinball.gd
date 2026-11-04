extends RigidBody2D


#this is a github desktop app test

func _physics_process(delta: float) -> void:
	if position.y > 1280:
		self.linear_velocity = Vector2.ZERO
		get_parent().ball_in_launcher = true
		self.global_transform.origin = Vector2(1035,957)
