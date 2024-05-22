extends StaticBody3D

@export_range(0, 1) var mesh_type = 0
@onready var _meshes = [$Mesh, $MeshGated]

func _ready():
	for i in _meshes.size():
		if _meshes[i] != _meshes[mesh_type]:
			_meshes[i].hide()
