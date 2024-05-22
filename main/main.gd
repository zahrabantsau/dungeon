extends Node3D

signal game_started

func _ready():
	$Game.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_start_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Menu.hide()
	$Game.show()
	game_started.emit()
