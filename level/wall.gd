extends StaticBody3D

@export_range(-1, 4, 1) var mesh_type = -1 # end range should be equal to meshes array last index
@onready var _meshes = [$Mesh, $MeshShelves, $MeshCracked, $MeshWindowClosed, $MeshDoor]

func _ready():
	if mesh_type > -1:
		_select_mesh(_meshes[mesh_type])
	else:
		_randomize_mesh()

func _randomize_mesh():
	var mesh = _meshes.pick_random()
	
	if mesh == $MeshDoor:
		# We don't want to include doors into randomization, so we are using basic mesh.
		_select_mesh($Mesh)
	else:
		_select_mesh(mesh)

func _select_mesh(mesh):
	for i in _meshes.size():
		if mesh != _meshes[i]:
			_meshes[i].hide()
