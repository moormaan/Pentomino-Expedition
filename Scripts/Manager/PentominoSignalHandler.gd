extends RigidBody3D

var ordinal: int
var collision_sound_player: AudioStreamPlayer

# Function to play the collision sound
func _on_body_entered(other_body: Node) -> void:
	if collision_sound_player == null:
		return

	if other_body is RigidBody3D:
		if (other_body.linear_velocity - linear_velocity).length() < 4:
			print("Collision speed below threshold")
			return
			
		print("Processing collision for pentomino: ", ordinal)
		var other_ordinal = other_body.ordinal

		if ordinal == null or other_ordinal == null:
			return

		elif ordinal < other_ordinal:
			collision_sound_player.play()

	elif other_body.name == "TableSurface":
		if linear_velocity.length() < 4:
			print("Collision speed with the table below threshold")
			return
		collision_sound_player.play()
