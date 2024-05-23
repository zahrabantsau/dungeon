class_name Player 
extends CharacterBody3D

signal on_portal_destroyed

@export var speed = 5
@export var acceleration = 5
@export var jump_strength = 10
@export var gravity = 50

@onready var _spring_arm = $Model/CameraArm
@onready var _model = $Model/Rig
@onready var _anim = $Model/AnimationPlayer
@onready var _weapon = $Model/Rig/Skeleton3D/Sword/SwordArea/SwordCollision

var _game_started = false

func damage(amount):
	queue_free()

func _physics_process(delta):
	if not _game_started:
		return
	
	var local_speed
	
	if _anim.current_animation != "2H_Melee_Attack_Chop" and \
	   _anim.current_animation != "2H_Melee_Attack_Spinning":
		_weapon.disabled = true
	else:
		_weapon.disabled = false
	
	if Input.is_action_pressed("run"):
		local_speed = speed * 1.5
	else:
		local_speed = speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_pressed("jump"):
			velocity.y = jump_strength
	
	var input = Input.get_vector("forward", "backwards", "right", "left")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, _spring_arm.rotation.y)
			
	if _anim.current_animation == "2H_Melee_Attack_Chop":
		# Preventing character from movements during base attack.
		velocity.x = 0
		velocity.z = 0
	else:
		velocity.x = dir.x * local_speed
		velocity.z = dir.z * local_speed
	_animate_player()
	move_and_slide()
	
	if velocity.length() > 1.0 and is_on_floor():
		_model.rotation.y = lerp_angle(_model.rotation.y, _spring_arm.rotation.y, speed * delta)

func _animate_player():
	if not is_on_floor():
		_animate("Jump_Idle")
		return
	
	var is_horizontal_movement = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	var is_vertical_movement = Input.is_action_pressed("forward") or Input.is_action_pressed("backwards")
	var is_player_moves = is_horizontal_movement or is_vertical_movement or Input.is_action_pressed("jump") or Input.is_action_pressed("attack") or Input.is_action_pressed("attack_strong")
	
	if Input.is_action_pressed("attack"):
		_animate("2H_Melee_Attack_Chop")
	elif Input.is_action_pressed("attack_strong"):
		_animate("2H_Melee_Attack_Spinning")
	if not (_anim.current_animation == "2H_Melee_Attack_Chop" or _anim.current_animation == "2H_Melee_Attack_Spinning"):
		if (Input.is_action_pressed("forward") or Input.is_action_pressed("backwards")) and not is_horizontal_movement:
			if Input.is_action_pressed("run"):
				_animate("Running_B")
			else:
				_animate("Running_A")
		if Input.is_action_pressed("left"):
			_animate("Running_Strafe_Left")
		if Input.is_action_pressed("right"):
			_animate("Running_Strafe_Right")
		if Input.is_action_pressed("jump"):
			_animate("Jump_Full_Short")
		if not is_player_moves:
			_animate("2H_Melee_Idle")
		if not is_player_moves and _anim.current_animation != "2H_Melee_Attack_Chop":
			_anim.stop()

func _animate(animation):
	if (_anim.current_animation != animation):
		_anim.stop()
	
	if animation == "2H_Melee_Attack_Chop":
		_anim.speed_scale = 4
	elif animation == "2H_Melee_Attack_Spinning":
		_anim.speed_scale = 2
	else:
		_anim.speed_scale = 1
		
	_anim.play(animation)

func _on_main_game_started():
	_game_started = true

func _on_sword_area_body_entered(body):
	if body is SkeletonWarrior:
		body.die()
	elif body is Portal:
		body.queue_free()
		on_portal_destroyed.emit()
