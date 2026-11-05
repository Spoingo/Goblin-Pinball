extends RigidBody2D

var rest_pull_rate = 150
var pull_rate = 150
var snap_rate = 1000
var max_extend = 200
var rest_ypos = 1080

func _physics_process(delta: float) -> void:
	if get_parent().ball_in_launcher:
		if Input.is_action_pressed("Rshift"):
			if position.y < rest_ypos+max_extend:
				pull_rate *= .97
				position.y += pull_rate*delta
			else:
				position.y = rest_ypos+max_extend
		elif position.y > rest_ypos:
			print(rest_pull_rate-pull_rate)
			snap_rate = (rest_pull_rate-pull_rate)*15
			position.y -= snap_rate*delta
		elif position.y <= rest_ypos:
			position.y = rest_ypos
			pull_rate = rest_pull_rate
