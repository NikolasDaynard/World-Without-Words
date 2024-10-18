extends RigidBody2D

# Speed at which the enemy moves
var speed: float = 400
const MAX_SPEED: float = 400
# Direction of movement: 1 for right, -1 for left
var direction: int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_HIT_STUN_TIME = .1
var hitTimer = MAX_HIT_STUN_TIME

# RayCast2D node for detecting walls
@onready var raycast = $WallRaycast
@onready var floor_raycast = $GroundRaycast
@onready var sprite = $Sprite2D

func _ready():
	# Enable the RayCast2D node
	raycast.add_exception(self) # disable collision with rigidbody

	var playerEntities = get_tree().get_nodes_in_group("player")
	for playerObject in playerEntities:
		raycast.add_exception(playerObject)
		add_collision_exception_with(playerObject)

func _process(delta):
	hitTimer += delta;
	# Update RayCast2D position and direction
	raycast.target_position = Vector2(direction * 90, 0)  # 20 pixels in the direction of movement
	raycast.force_raycast_update()
	# If the RayCast2D detects a wall, reverse direction
	if raycast.is_colliding():
		# print("col")
		direction *= -1
		linear_velocity.x = 0

	# Set velocity based on direction and speed
	linear_velocity.x += direction * speed * delta
	linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)

	linear_velocity.x = move_toward(linear_velocity.x, 0, .1)
	if not floor_raycast.is_colliding():
		linear_velocity.y += gravity * delta

	if hitTimer < MAX_HIT_STUN_TIME:
		if int(hitTimer * 8) % 2 == 0:
			sprite.set("material", preload("res://entities/enemy/whiteFlash.material"))
		else: 
			sprite.set("material", null)
	else:
		sprite.set("material", null)
	# velocity.y = move_toward(velocity.y, 0, .1)
	# velocity *= .3

# func apply_force(force_direction: Vector2, force: float):
# 	force_direction.y = -abs(force_direction.y)
# 	velocity = force_direction * force

func hit(hit_direction: Vector2, force: float):
	linear_velocity = hit_direction * force
	hitTimer = 0
	pass


func _on_hitbox_body_entered(body):
	print(body)
	if body.has_method("hit") and body.is_in_group("player"):
		body.hit(body.global_position - global_position, 15)
		print("player")
	pass # Replace with function body.
