extends Node

func create_pentomino_mesh(pentomino: PentominoDefinition) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	add_horizontal_mesh_face(st, pentomino, 0, false)  # Bottom face
	add_horizontal_mesh_face(st, pentomino, 1, true)   # Top face
	add_vertical_mesh_sides(st, pentomino)
	var mesh = st.commit()
	
	# Create a material and set its albedo color
	var material = StandardMaterial3D.new()
	material.albedo_color = pentomino.color
	material.metallic_specular = 0.5
	material.roughness = 0.5
	
	# Assign the material to the mesh
	mesh.surface_set_material(0, material)
	
	return mesh


func add_horizontal_mesh_face(st: SurfaceTool, pentomino: PentominoDefinition, y: int, is_up: bool):
	for definition_y in range(pentomino.height()):
		for definition_x in range(pentomino.width()):
			if pentomino.shape[definition_y][definition_x] == 1:
				add_horizontal_square(st, definition_x, y, definition_y, is_up)


func add_horizontal_square(st: SurfaceTool, x: int, y: int, z: int, is_up: bool):
	if is_up:
		# Add two triangles to form a square facing up
		st.set_normal(Vector3(0, 1, 0))
		st.add_vertex(Vector3(x, y, z))
		st.add_vertex(Vector3(x + 1, y, z))
		st.add_vertex(Vector3(x, y, z + 1))
		
		st.add_vertex(Vector3(x + 1, y, z))
		st.add_vertex(Vector3(x + 1, y, z + 1))
		st.add_vertex(Vector3(x, y, z + 1))
	else:
		# Add two triangles to form a square facing down
		st.set_normal(Vector3(0, -1, 0))
		st.add_vertex(Vector3(x, y, z + 1))
		st.add_vertex(Vector3(x + 1, y, z))
		st.add_vertex(Vector3(x, y, z))
		
		st.add_vertex(Vector3(x, y, z + 1))
		st.add_vertex(Vector3(x + 1, y, z + 1))
		st.add_vertex(Vector3(x + 1, y, z))


func add_vertical_mesh_sides(st: SurfaceTool, pentomino: PentominoDefinition):
	for y in range(pentomino.height()):
		for x in range(pentomino.width()):
			if pentomino.shape[y][x] == 1:
				# Check the right edge
				if (x + 1 < pentomino.width() and pentomino.shape[y][x + 1] == 0) or x + 1 == pentomino.width():
					add_vertical_square(st, x + 1, 0, y, x + 1, 1, y + 1, Vector3(1, 0, 0))
				# Check the left edge
				if (x - 1 >= 0 and pentomino.shape[y][x - 1] == 0) or x - 1 < 0:
					add_vertical_square(st, x, 0, y, x, 1, y + 1, Vector3(-1, 0, 0))
				# Check the front edge
				if (y + 1 < pentomino.height() and pentomino.shape[y + 1][x] == 0) or y + 1 == pentomino.height():
					add_vertical_square(st, x, 1, y + 1, x + 1, 0, y + 1, Vector3(0, 0, 1))
				# Check the back edge
				if (y - 1 >= 0 and pentomino.shape[y - 1][x] == 0) or y - 1 < 0:
					add_vertical_square(st, x, 1, y, x + 1, 0, y, Vector3(0, 0, -1))


func add_vertical_square(st: SurfaceTool, x1: int, y1: int, z1: int, x2: int, y2: int, z2: int, facing: Vector3):
	# Use the provided facing direction as the normal
	var normal = facing.normalized()
	
	# Determine the order of vertices based on the facing direction
	if facing == Vector3(1, 0, 0) or facing == Vector3(0, 0, 1):  # Right or Front
		st.set_normal(normal)

		st.add_vertex(Vector3(x1, y1, z1))
		st.add_vertex(Vector3(x2, y2, z2))
		st.add_vertex(Vector3(x1, y2, z1))
		
		st.add_vertex(Vector3(x1, y1, z1))
		st.add_vertex(Vector3(x2, y1, z2))
		st.add_vertex(Vector3(x2, y2, z2))

	else:  # Left or Back
		st.set_normal(normal)

		st.add_vertex(Vector3(x1, y1, z1))
		st.add_vertex(Vector3(x1, y2, z1))
		st.add_vertex(Vector3(x2, y2, z2))
		
		st.add_vertex(Vector3(x1, y1, z1))
		st.add_vertex(Vector3(x2, y2, z2))
		st.add_vertex(Vector3(x2, y1, z2))

