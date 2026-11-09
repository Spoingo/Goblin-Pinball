extends Node2D

@onready var pinball = find_child("Pinball")

@onready var pinball_y_location = 0

var wave = 1

var wiping_screen = false
var wipe_point = 0

var ball_in_launcher = true

var enemy_count = 0


func _ready() -> void:
	spawn_wave()

func _process(delta: float) -> void:
	pinball_y_location = pinball.global_position.y + 45
	if ball_in_launcher:
		$LaunchDetect.monitoring = true
		$LaunchBlock.rotation_degrees = -90
		$LaunchBlock2.rotation_degrees = -90
		$FlickBlock.rotation_degrees = 55
	
	

	else:
		$LaunchDetect.monitoring = false
	if enemy_count <= 1:
		wave += 1
		spawn_wave()
	
	if Input.is_action_pressed("Lshift") and Input.is_action_pressed("Rshift"):
		if $wipe.is_stopped():
			$wipe.start(1.0)
	elif !$wipe.is_stopped():
		$wipe.stop()
	if wiping_screen:
		wipe_screen(delta)

func _on_timer_timeout() -> void:
	$LaunchBlock.rotation_degrees = -84
	$LaunchBlock2.rotation_degrees = -90


func _on_launch_detect_body_entered(body: Node2D) -> void:
	if body == pinball:
		ball_in_launcher = false
		$LaunchBlock.rotation_degrees = -44
		$LaunchBlock2.rotation_degrees = -140
		#$CenterRiser.position.y = 1047
		$LaunchBlock/Timer.start()
		$FlickBlock/FlickBlockTimer.start()
		#$CenterRiser/RiserTimer.start()


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


func _on_riser_timer_timeout() -> void:
	$CenterRiser.position.y = 1847


func wipe_screen(delta):
	if wipe_point <= get_window().size.x:
		wipe_point += 200*delta
		$Wiper.position.x = wipe_point
		for enemy in $Enemies.get_children():
			if wipe_point >= enemy.global_position.x:
				if enemy.dead:
					enemy.wipe()
	else:
		wipe_point = 0
		$Wiper.position.x = wipe_point - $Wiper.size.x
		wiping_screen = false

func spawn_wave():
	var wave_spawns = []
	#if wave == 1:
	wave_spawns = [
		#[nodepath,position]
		["res://peon.tscn",Vector2(150,275)],
		["res://peon.tscn",Vector2(300,390)],
		["res://peon.tscn",Vector2(450,275)],
		["res://peon.tscn",Vector2(600,390)],
		["res://peon.tscn",Vector2(750,275)]
	]
	enemy_count += wave_spawns.size()
	print(wave_spawns.size())
	
	for enemy in wave_spawns:
		var enemy_spawn = load(enemy[0]).instantiate()
		enemy_spawn.spawn_position = enemy[1]
		enemy_spawn.position = enemy[1]
		enemy_spawn.position.y = -4
		$Enemies.add_child(enemy_spawn)
	



func _on_wipe_timeout() -> void:
	wipe_point = 0
	wiping_screen = true
