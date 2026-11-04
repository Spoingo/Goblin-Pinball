extends RigidBody2D

var rotation_value = -15



func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Rshift"):
		if rotation_value < 45:
			rotation_value += 700*delta
		elif rotation_value <= 45:
			rotation_value = 45
	else:
		if rotation_value > -15:
			rotation_value -= 700 * delta
		if rotation_value >= -15:
			rotation_value = -15
	rotation_degrees = rotation_value
