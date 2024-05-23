class_name SkeletonWarrior
extends CharacterBody3D

# Animations
const _attack_animations = ["Unarmed_Melee_Attack_Kick", "Unarmed_Melee_Attack_Punch_A", "Unarmed_Melee_Attack_Punch_B"]
const _death_animation = "Death_A"
const _idle_animation = "Idle_Combat"
const _move_animation = "Running_A"

# Physics
const _gravity = 0.5
const _base_speed = 5

@onready var _anim = $Model/AnimationPlayer
@onready var _collision = $Collision
@onready var _hitbox = $Hitbox/Collision
@onready var _model = $Model
@onready var _timer = $Timer
@onready var _pathfinder = $Pathfinder

var _apply_gravity = false
var _is_dead = false
var _player : Player
var _speed = clamp(randf() * _base_speed, 1.0 * _base_speed, 2.0 * _base_speed)

func die():
	if _is_dead:
		return
	
	_is_dead = true
	_apply_gravity = true
	_collision.set_deferred("disabled", true)
	_hitbox.set_deferred("disabled", true)
	_anim.play(_death_animation)

func _ready():
	_timer.one_shot = true
	_anim.speed_scale = _speed / _base_speed
	_anim.play(_move_animation)
	_player = get_tree().get_first_node_in_group("player")
	_model.rotate_y(deg_to_rad(180))

func _physics_process(delta):
	if _is_dead:
		position.y -= _gravity * delta
	elif _player != null:
		if _player.global_position.distance_to(global_position) > 1:
			_anim.play(_move_animation)
			var direction = Vector3()
			
			_pathfinder.target_position = _player.global_position
			var next_position = _pathfinder.get_next_path_position()
			direction = next_position - global_position
			direction = direction.normalized()
			look_at_from_position(global_position, Vector3(_player.global_position.x, 0, _player.global_position.z))
			rotation.x = deg_to_rad(0)
			velocity = velocity.lerp(direction * _speed, _speed * delta)
			move_and_slide()
		elif not _anim.is_playing() or _anim.current_animation == _move_animation:
			_anim.play(_attack_animations.pick_random())

func _on_animation_player_animation_finished(anim_name):
	if anim_name == _death_animation:
		_timer.timeout.connect(queue_free)
		_timer.start(2)

func _on_damage_area_body_entered(body):
	if body is Player:
		_timer.timeout.connect(Callable(_damage_player))
		_timer.start(1)

func _on_damage_area_body_exited(body):
	if body is Player:
		_timer.timeout.disconnect(Callable(_damage_player))

func _damage_player():
	_player.damage(15)
