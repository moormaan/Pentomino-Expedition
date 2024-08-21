extends Node

var mesh_operations = preload("res://Scripts/Manager/MeshOperations.gd").new()

var pentomino_definitions = [
	PentominoDefinition.new("Z", [[1, 1, 0],
								  [0, 1, 0],
								  [0, 1, 1]], Color(0.3, 1, 1)),
	PentominoDefinition.new("S", [[0, 1, 1, 1],
								  [1, 1, 0, 0]], Color(0.5, 0, 0.75)),
	PentominoDefinition.new("F", [[0, 1, 1],
								  [1, 1, 0],
								  [0, 1, 0]], Color(0.42, 0.42, 0.42)),
	PentominoDefinition.new("L", [[1, 1, 1, 1],
								  [1, 0, 0, 0]], Color(0.9, 0.4, 0.3)),
	PentominoDefinition.new("U", [[1, 0, 1],
								  [1, 1, 1]], Color(1, 1, 0.12)),
	PentominoDefinition.new("T", [[1, 1, 1],
								  [0, 1, 0],
								  [0, 1, 0]], Color(0.13, 0.7, 0.25)),
	PentominoDefinition.new("I", [[1, 1, 1, 1, 1]], Color(0.12, 0.12, 1)),
	PentominoDefinition.new("G", [[1, 1, 1],
								  [0, 0, 1],
								  [0, 0, 1]], Color(0, 0.72, 0.9)),
	PentominoDefinition.new("P", [[1, 1, 1],
								  [1, 1, 0]], Color(1, 0.45, 0.55)),
	PentominoDefinition.new("W", [[1, 0, 0],
								  [1, 1, 0],
								  [0, 1, 1]], Color(0.45, 1, 0.45)),
	PentominoDefinition.new("X", [[0, 1, 0],
								  [1, 1, 1],
								  [0, 1, 0]], Color(1, 0.15, 0.15)),
	PentominoDefinition.new("Y", [[1, 1, 1, 1],
								  [0, 1, 0, 0]], Color(0.48, 0.14, 0.11))
]


func pentomino_height(pentomino_index: int):
	return pentomino_definitions[pentomino_index].shape.size()


func pentomino_width(pentomino_index: int):
	return pentomino_definitions[pentomino_index].shape[0].size()


func pentomino_center_of_mass(pentomino_index: int):
	var shape = pentomino_definitions[pentomino_index].shape
	var center = Vector3(0, 0, 0)
	var total_mass = 0
	for i in shape.size():
		for j in shape[i].size():
			if shape[i][j] == 1:
				center += Vector3(j + 0.5, 0.5, i + 0.5)
				total_mass += 1
	return center / total_mass


func add_pentomino_mesh(pentomino_index: int, parent: Node3D, instance_position: Vector3) -> MeshInstance3D:
	var instance = MeshInstance3D.new()
	instance.mesh = mesh_operations.create_pentomino_mesh(pentomino_definitions[pentomino_index])
	instance.transform.origin = instance_position
	
	parent.add_child(instance)
	return instance


func add_pentomino_rigid_body(
		pentomino_index: int,
		parent: Node3D,
		instance_position: Vector3,
		rotation_x: float,
		rotation_y: float,
		rotation_z: float) -> RigidBody3D:

	var rigid_body_instance = RigidBody3D.new()
	var mesh_instance = add_pentomino_mesh(pentomino_index, rigid_body_instance, Vector3(0, 0, 0))

	rigid_body_instance.mass = 5
	
	# Set the collision shape to be the same as the mesh
	var shape = ConvexPolygonShape3D.new()
	var arrays = mesh_instance.mesh.surface_get_arrays(0)
	shape.set_points(arrays[Mesh.ARRAY_VERTEX])
	
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape
	rigid_body_instance.add_child(collision_shape)

	rigid_body_instance.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	rigid_body_instance.center_of_mass = pentomino_center_of_mass(pentomino_index)
	rigid_body_instance.linear_damp = 0.5

	# Apply rotations
	rigid_body_instance.rotate_x(rotation_x)
	rigid_body_instance.rotate_y(rotation_y)
	rigid_body_instance.rotate_z(rotation_z)

	rigid_body_instance.transform.origin = instance_position
	
	parent.add_child(rigid_body_instance)
	return rigid_body_instance
