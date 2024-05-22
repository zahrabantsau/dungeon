extends SpringArm3D

@export var mouse_sensitivity = 0.3
@export var touch_sensitivity = 1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		_camera_limits()

func _camera_limits():
	rotation_degrees.x = clamp(rotation_degrees.x, -45, 30)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)

