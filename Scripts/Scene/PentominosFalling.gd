extends Node3D

var pentomino_manager = preload("res://Scripts/Manager/PentominoManager.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Use add_pentomino_rigid_body to add an instance of every pentomino to 
	# the scene with a random position above the table and random rotations
	for i in 12:
		for wave in 1:
			pentomino_manager.add_pentomino_rigid_body(
				i, 
				self, 
				Vector3(
					randf_range(-7, 7), 
					20 * (wave + 1) * randf_range(0.7, 1.3), 
					randf_range(-7, 7)), 
				randf_range(-PI, PI), 
				randf_range(-PI, PI), 
				randf_range(-PI, PI))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
