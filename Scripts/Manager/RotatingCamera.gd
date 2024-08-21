extends Camera3D

# Define the normal vector of the plane in which the camera circles
var plane_normal = Vector3(1, 1, 1)  # Default to the XZ plane (horizontal plane)
var radius = 12.0  # Radius of the circle
var speed = 0.3  # Speed of circling

var angle = 0.0  # Current angle in radians

func _ready():
	# Normalize the plane normal vector
	plane_normal = plane_normal.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the angle based on the speed and elapsed time
	angle += speed * delta
	
	# Calculate the camera's position on the circle
	var x = radius * cos(angle)
	var z = radius * sin(angle)
	
	# Calculate the camera's position in the plane defined by the normal vector
	var camera_position = Vector3(x, 0, z).rotated(plane_normal, plane_normal.angle_to(Vector3(0, 1, 0)))
	
	# Set the camera's position
	global_transform.origin = camera_position
	
	# Make the camera look at the origin
	look_at(Vector3(0, 0, 0), plane_normal)
