extends Node2D


var L_rotation_value = 15
var R_rotation_value = -15

var left_flipper
var right_flipper

var left_flipper_rest = 20
var right_flipper_rest

var left_flipper_extend = -40
var right_flipper_extend

var flip_force = 1350



func _physics_process(delta: float) -> void:
	
	if !get_parent().ball_in_launcher:
		if Input.is_action_pressed("Lshift"):
			left_flipper = true
		elif L_rotation_value <= left_flipper_extend:
			left_flipper = false
		if left_flipper:
			if L_rotation_value > left_flipper_extend:
				L_rotation_value -= flip_force*delta
			elif L_rotation_value <= left_flipper_extend:
				L_rotation_value = left_flipper_extend
		else:
			if L_rotation_value < left_flipper_rest:
				L_rotation_value += flip_force * delta
			if L_rotation_value >= left_flipper_rest:
				L_rotation_value = left_flipper_rest
		if Input.is_action_pressed("Rshift"):
			right_flipper = true
		elif R_rotation_value >= 220:
			right_flipper = false
		if right_flipper:
			if R_rotation_value < 220:
				R_rotation_value += flip_force*delta
			elif R_rotation_value >= 220:
				R_rotation_value = 220
		else:
			if R_rotation_value > 160:
				R_rotation_value -= flip_force * delta
			if R_rotation_value <= 160:
				R_rotation_value = 160
	else:
		if R_rotation_value > 160:
			R_rotation_value -= flip_force * delta
		if R_rotation_value <= 160:
			R_rotation_value = 160
		if L_rotation_value < left_flipper_rest:
			L_rotation_value += flip_force * delta
		if L_rotation_value >= left_flipper_rest:
			L_rotation_value = left_flipper_rest
	$Lflipper.rotation_degrees = L_rotation_value
	$Rflipper.rotation_degrees = R_rotation_value
