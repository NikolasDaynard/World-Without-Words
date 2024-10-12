extends RigidBody2D

# Speed at which the enemy moves
var speed: float = 100
# Direction of movement: 1 for right, -1 for left
var direction: int = 1

# RayCast2D node for detecting walls
@onready var raycast = $RayCast2D

func _ready():
	# Enable the RayCast2D node
	raycast.enabled = true
	raycast.add_exception(self) # disable collision with rigidbody

func _integrate_forces(_state):
	# Update RayCast2D position and direction
	raycast.target_position = Vector2(direction * 90, 0)  # 20 pixels in the direction of movement
	raycast.force_raycast_update()
	# If the RayCast2D detects a wall, reverse direction
	if raycast.is_colliding():
		print("col")
		direction *= -1

	# Set velocity based on direction and speed
	linear_velocity = Vector2(direction * speed, 0)
	global_rotation = 0
