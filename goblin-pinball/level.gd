extends Node2D

@onready var pinball = find_child("Pinball")

var ball_in_launcher = true

func _process(delta: float) -> void:
	if ball_in_launcher:
		$LaunchDetect.monitoring = true
		$LaunchBlock.rotation_degrees = -90
		$LaunchBlock2.rotation_degrees = -90
		$FlickBlock.rotation_degrees = 55
		

	else:
		$LaunchDetect.monitoring = false


func _on_timer_timeout() -> void:
	$LaunchBlock.rotation_degrees = -70
	$LaunchBlock2.rotation_degrees = -90


func _on_launch_detect_body_entered(body: Node2D) -> void:
	if body == pinball:
		ball_in_launcher = false
		$LaunchBlock.rotation_degrees = -34
		$LaunchBlock2.rotation_degrees = -144
		$LaunchBlock/Timer.start()
		$FlickBlock/FlickBlockTimer.start()


func _on_Lbumper_body_entered(body: Node2D) -> void:
	if body == pinball:
		
		var bounce_strength = 1500.0
		var push_dir = Vector2(0, 1).rotated($LBumper/CollisionShape2D.global_rotation).normalized()
		var incoming_velocity_component: float = body.linear_velocity.dot(push_dir)
		
		if incoming_velocity_component < 0:
			body.linear_velocity -= push_dir * incoming_velocity_component
		body.apply_central_impulse(push_dir * bounce_strength)
		
		$LBumper/BumpSprite.visible = true
		await get_tree().create_timer(0.1).timeout
		$LBumper/BumpSprite.visible = false
		
		#<ROUND> POP BUMPER CODE
		#var bounce_strength = 7000.0
		#var push_dir = (body.global_position-global_position).normalized()
		#body.apply_central_impulse(push_dir*bounce_strength)


func _on_Rbumper_body_entered(body: Node2D) -> void:
	if body == pinball:
		
		var bounce_strength = 1500.0
		var push_dir = Vector2(0, 1).rotated($RBumper/CollisionShape2D.global_rotation).normalized()
		var incoming_velocity_component: float = body.linear_velocity.dot(push_dir)
		
		if incoming_velocity_component < 0:
			body.linear_velocity -= push_dir * incoming_velocity_component
		body.apply_central_impulse(push_dir * bounce_strength)
		
		$RBumper/BumpSprite.visible = true
		await get_tree().create_timer(0.1).timeout
		$RBumper/BumpSprite.visible = false


func _on_flick_block_timer_timeout() -> void:
	$FlickBlock.rotation_degrees = 90

func spring_compression(amount: float) -> void:
	$Spring.add_theme_constant_override(
		"separation",
		roundi(lerpf(-117, -200, clampf(amount, 0.0, 1.0)))
	)


func new_ball():
	var ball = load("res://pinball.tscn").instantiate()
	pinball = ball
	ball.global_position = Vector2(1035,990)
	ball_in_launcher = true
	add_child(ball)
