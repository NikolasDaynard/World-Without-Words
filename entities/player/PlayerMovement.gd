extends CharacterBody2D


const GROUND_ACCEL = 200
const AIR_ACCEL = 70
const MAX_SPEED = 600.0
var jumpVelocityIteration = 0 # stores total jumping velocity added
const MAX_JUMP_VELOCITY = -1000 
const JUMP_VELOCITY = -200
var timeSinceLastJump = 0
const WALLJUMP_DELAY = .3 # seconds
const WALLJUMP_VELOCITY = JUMP_VELOCITY * 6 
var timeSinceTouchingWall = 0
const WALLJUMP_COYOTE_TIME = .2 # time off a wall until not able to jump
# todo make walls sticky rather than coyote time
var facing_direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	timeSinceLastJump += delta
	timeSinceTouchingWall += delta

func _physics_process(delta):
	var accel_fac = 0

	# Add the gravity.
	if not is_on_floor():
		accel_fac = AIR_ACCEL
		velocity.y += gravity * delta
	else:
		jumpVelocityIteration = 0
		accel_fac = GROUND_ACCEL

	if is_on_wall():
		timeSinceTouchingWall = 0


	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		if jumpVelocityIteration > MAX_JUMP_VELOCITY:
			velocity.y += JUMP_VELOCITY - (gravity * delta) # cancel grav
			jumpVelocityIteration += JUMP_VELOCITY
			timeSinceLastJump = 0
		elif timeSinceTouchingWall < WALLJUMP_COYOTE_TIME and timeSinceLastJump > WALLJUMP_DELAY:
			velocity.y = WALLJUMP_VELOCITY
			timeSinceLastJump = 0

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * accel_fac
		facing_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, accel_fac)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	move_and_slide()
