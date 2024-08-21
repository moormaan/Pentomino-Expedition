extends OmniLight3D

var angle = 0.0  # Initial angle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rotate_in_plane(0.5, delta, 10.0)

# Function to rotate the light source in its plane with a given angular speed
func rotate_in_plane(angular_speed, delta, radius):
    angle += angular_speed * delta
    var new_x = radius * cos(angle)
    var new_z = radius * sin(angle)
    global_transform.origin.x = new_x
    global_transform.origin.z = new_z