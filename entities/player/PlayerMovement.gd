extends CharacterBody2D

@onready var sprite = $"Sprite2D"

const MOVESPEED = 210
const GROUND_ACCEL = MOVESPEED
const GROUND_DECEL = GROUND_ACCEL
const AIR_ACCEL = MOVESPEED * .4
const AIR_DECEL = AIR_ACCEL * .5
const MAX_SPEED = MOVESPEED * 3
var jumpVelocityIteration = 0 # stores total jumping velocity added
const MAX_JUMP_VELOCITY = -1000 
const MIN_JUMP_VELOCITY = -500 
const JUMP_VELOCITY = -200
var timeSinceLastJump = 0
const WALLJUMP_DELAY = .3 # seconds
const WALLJUMP_VELOCITY = JUMP_VELOCITY * 6 
const WALLJUMP_HORIZONTAL_VELOCITY = -JUMP_VELOCITY * 5
var timeSinceTouchingWall = 0
const WALLJUMP_COYOTE_TIME = .2 # time off a wall until not able to jump
var holdingJump = false;
const WALLSLIDE_GRAV_FACTOR = .5
const MAX_WALLSLIDE_VELOCITY = 300
# todo make walls sticky rather than coyote time
var facing_direction = 1

var holdingRoll = false
const ROLL_SPEED = MOVESPEED * 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	timeSinceLastJump += delta
	timeSinceTouchingWall += delta

	if Input.is_action_just_pressed("roll"):
		holdingRoll = true
	if Input.is_action_just_released("roll"):
		holdingRoll = false

	if holdingRoll:
		sprite.rotation += 10 * delta
		if is_on_floor():
			velocity.x = facing_direction * ROLL_SPEED
		else:
			if velocity.y > 0:
				velocity.y -= gravity * delta * .6

func _physics_process(delta):
	var accel_fac = 0
	var decel_fac = 0

	# Add the gravity.
	if not is_on_floor():
		accel_fac = AIR_ACCEL
		decel_fac = AIR_DECEL
			
		if !is_on_wall():
			velocity.y += gravity * delta
		else:
			if velocity.y > 0:
				velocity.y += gravity * delta * WALLSLIDE_GRAV_FACTOR
				velocity.y = clamp(velocity.y, 0, MAX_WALLSLIDE_VELOCITY)
			else:
				velocity.y += gravity * delta
	else:
		jumpVelocityIteration = 0
		accel_fac = GROUND_ACCEL
		decel_fac = GROUND_DECEL

	if is_on_wall():
		timeSinceTouchingWall = 0

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			holdingJump = true
		if jumpVelocityIteration > MAX_JUMP_VELOCITY and holdingJump:
			jump(JUMP_VELOCITY, delta)
		elif timeSinceTouchingWall < WALLJUMP_COYOTE_TIME and timeSinceLastJump > WALLJUMP_DELAY:
			velocity.y = WALLJUMP_VELOCITY
			velocity.x += get_wall_normal().x * WALLJUMP_HORIZONTAL_VELOCITY
			timeSinceLastJump = 0
	else:
		if (jumpVelocityIteration != 0 and jumpVelocityIteration > MIN_JUMP_VELOCITY):
			jump(JUMP_VELOCITY, delta)
		holdingJump = false

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var newXVel = velocity.x + direction * accel_fac
		# regular case
		if clamp(newXVel, -MAX_SPEED, MAX_SPEED) == newXVel:
			velocity.x = newXVel
		# is new velocity closer to in bounds
		elif velocity.x > MAX_SPEED and newXVel < velocity.x:
			velocity.x = newXVel
		elif velocity.x < -MAX_SPEED and newXVel > velocity.x:
			velocity.x = newXVel

		if clamp(velocity.x, -MAX_SPEED, MAX_SPEED) != velocity.x:
			velocity.x = move_toward(velocity.x, 0, decel_fac)

		facing_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, decel_fac)
	move_and_slide()

func jump(force, jdelta):
	velocity.y += force - (gravity * jdelta) # cancel grav
	jumpVelocityIteration += force
	timeSinceLastJump = 0

func hit(direction, force):
	velocity = direction * force
	pass
