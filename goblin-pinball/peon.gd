extends AnimatableBody2D


@onready var pinball_y_location = get_parent().get_parent().pinball_y_location

var speed = 50

var dir = Vector2.ZERO

var stopped

var dead = false

func _process(delta: float) -> void:
	if !dead:
		pinball_y_location = get_parent().get_parent().pinball_y_location
		if global_position.y > pinball_y_location:
			z_index = 3
		else:
			z_index = 1

func _physics_process(delta: float) -> void:
	if !stopped:
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

func wipe():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != self:
		die()



func _on_move_timer_timeout() -> void:
	if stopped:
		stopped = false
		dir = Vector2.RIGHT.rotated(randf()*TAU)
		$AnimatedSprite2D.play("default")
	else:
		stopped = true
		$AnimatedSprite2D.stop()
	$MoveTimer.start(randf_range(2.0,5.0))


func _on_despawn_timeout() -> void:
	queue_free()
