class_name SkeletonWarrior
extends CharacterBody3D

# Animations
const _death_animation = "Death_A"
const _idle_animation = "Idle_Combat"

# Physics
const _gravity = 0.5
const _speed = 5

@onready var _anim = $Model/AnimationPlayer
@onready var _collision = $Collision
@onready var _hitbox = $Hitbox/Collision
@onready var _timer = $Timer
@onready var _pathfinder = $Pathfinder

var _apply_gravity = false
var _is_dead = false
var _player : Player

func die():
	if _is_dead:
		return
	
	_is_dead = true
	_apply_gravity = true
	_collision.set_deferred("disabled", true)
	_hitbox.set_deferred("disabled", true)
	_anim.play(_death_animation)

func _ready():
	_anim.play(_idle_animation)
	_player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if _is_dead:
		position.y -= _gravity * delta
	elif _player != null:
		var direction = Vector3()
		
		_pathfinder.target_position = _player.global_position
		var next_position = _pathfinder.get_next_path_position()
		direction = next_position - global_position
		var target_position = position.direction_to(next_position)
		target_position = Vector3(target_position.x, 0, target_position.z)
		look_at(target_position)
		#direction = direction.normalized()
		
		#velocity = velocity.lerp(direction * _speed, _speed * delta)
		#move_and_slide()
		move_and_collide(target_position * delta * _speed)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == _death_animation:
		_timer.timeout.connect(queue_free)
		_timer.start(3)
