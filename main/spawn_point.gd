extends Node3D

@export var first_spawn_size = 5
@onready var _timer = $SpawnTimer

var _warrior_scene = preload("res://creatures/skeleton_warrior.tscn")
var _dungeon : Node3D

func _ready():
	_dungeon = get_tree().get_first_node_in_group("dungeon")

func _spawn_warrior(offset):
	var warrior = _warrior_scene.instantiate() as SkeletonWarrior
	warrior.position = position + Vector3(offset, 0, offset)
	warrior.scale *= 0.8
	_dungeon.call_deferred("add_child", warrior)

func _on_main_game_started():
	for i in first_spawn_size:
		_spawn_warrior(i)
	_timer.one_shot = false
	_timer.timeout.connect(Callable(_spawn_warrior.bind(0)))
	_timer.start(5)

func _on_player_on_portal_destroyed():
	queue_free()
