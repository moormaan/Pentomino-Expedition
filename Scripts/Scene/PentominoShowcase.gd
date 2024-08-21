extends Node3D

@onready var percussion_player: AudioStreamPlayer = $PercussionPlayer
@onready var pentomino_container: Node3D = $PentominoContainer

var mesh_operations = preload("res://Scripts/Manager/MeshOperations.gd").new()
var pentomino_manager = preload("res://Scripts/Manager/PentominoManager.gd").new()

var x_offset = -7
var z_offset = -7

func add_all_pentominos(parent: Node3D):
	var next_instance_position = Vector3(x_offset, 0, z_offset)
	for i in 3:

		var widest_so_far = 0
		for j in 4:
			var index = i * 4 + j
			print("Adding pentomino " + str(index))

			var pentomino = pentomino_manager.add_pentomino_rigid_body(
				index,
				parent,
				next_instance_position,
				0,
				0,
				0) 
			pentomino.gravity_scale = 0

			var pentomino_height = pentomino_manager.pentomino_height(index)
			var pentomino_width = pentomino_manager.pentomino_width(index)

			next_instance_position.z += pentomino_height + 1
			if pentomino_width > widest_so_far:
				widest_so_far = pentomino_width

		next_instance_position.z = z_offset
		next_instance_position.x += widest_so_far + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add all pentominos
	add_all_pentominos(pentomino_container)
	percussion_player.play()
