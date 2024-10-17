extends Area2D

# Speed at which the enemy moves
var speed: float = 100
# Direction of movement: 1 for right, -1 for left
var direction: int = 1
var velocity = Vector2(0, 0)

# RayCast2D node for detecting walls
@onready var raycast = $RayCast2D

func _ready():
	# Enable the RayCast2D node
	raycast.add_exception(self) # disable collision with rigidbody
	
	var playerEntities = get_tree().get_nodes_in_group("player")
	for playerObject in playerEntities:
		raycast.add_exception(playerObject)

func _process(delta):
	# Update RayCast2D position and direction
	raycast.target_position = Vector2(direction * 90, 0)  # 20 pixels in the direction of movement
	raycast.force_raycast_update()
	# If the RayCast2D detects a wall, reverse direction
	if raycast.is_colliding():
		# print("col")
		direction *= -1

	# Set velocity based on direction and speed
	global_position += Vector2(direction * speed * delta, 0)
	global_position += velocity

	velocity.x = move_toward(velocity.x, 0, .1)
	velocity.y = move_toward(velocity.y, 0, .1)
	velocity *= .3
	

func _on_body_entered(body):
	# print(body)
	if body.has_method("hit") and body.is_in_group("player"):
		body.hit(body.global_position - global_position, 15)
	pass

func apply_force(force_direction: Vector2, force: float):
	force_direction.y = -abs(force_direction.y)
	velocity = force_direction * force

func hit(hit_direction: Vector2, force: float):
	velocity = hit_direction * force
	pass
