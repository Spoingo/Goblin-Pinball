extends AnimatableBody2D


@onready var pinball_y_location = get_parent().get_parent().pinball_y_location

var speed = 50

var dir = Vector2.ZERO
var x_dir_flip = false
var y_dir_flip =  false

var stopped

var dead = false

var spawn_position

var spawning = true

func _process(delta: float) -> void:
	if !dead:
		pinball_y_location = get_parent().get_parent().pinball_y_location
		if global_position.y > pinball_y_location:
			z_index = 3
		else:
			z_index = 1

func _physics_process(delta: float) -> void:
	if spawning:
		dir = global_position.direction_to(spawn_position)
		if round(global_position) == spawn_position:
			spawning = false
			stopped = true
			$MoveTimer.start(5)
		if !dead:
			global_position += speed*dir*delta
	elif !stopped and !dead:
		if global_position.x+50 >= get_window().size.x or global_position.x-50 <= 0:
			if !x_dir_flip:
				x_dir_flip = true
				dir.x *= -1
		if global_position.y+400 >= get_window().size.y or global_position.y <= 100:
			if !y_dir_flip:
				y_dir_flip = true
				dir.y *= -1
		global_position += speed*dir*delta
		if dir.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true


func die():
	dead = true
	z_index = 0
	$MoveTimer.stop()
	stopped = true
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible = false
	$Sprite2D.visible = true
	get_parent().get_parent().enemy_count -= 1

func wipe():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != self:
		#body.apply_central_force(-body.linear_velocity * 50)
		die()



func _on_move_timer_timeout() -> void:
	if stopped:
		stopped = false
		dir = Vector2.RIGHT.rotated(randf()*TAU)
		
		$AnimatedSprite2D.play("default")
	else:
		stopped = true
		x_dir_flip = false
		y_dir_flip = false
		$AnimatedSprite2D.stop()
	$MoveTimer.start(randf_range(1.0,7.0))


func _on_despawn_timeout() -> void:
	queue_free()
