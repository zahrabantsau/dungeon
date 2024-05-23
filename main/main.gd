extends Node3D

signal game_started

func _ready():
	$Game.hide()
	$Menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	if get_tree().get_nodes_in_group("creature").size() <= 0:
		$SuccessScreen.show()

func _on_start_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Menu.hide()
	$Game.show()
	game_started.emit()
