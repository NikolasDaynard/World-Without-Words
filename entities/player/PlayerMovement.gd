extends CharacterBody2D

const MOVESPEED = 210
const GROUND_ACCEL = MOVESPEED
const GROUND_DECEL = GROUND_ACCEL * .5
const AIR_ACCEL = MOVESPEED * .35
const AIR_DECEL = AIR_ACCEL * .5
const MAX_SPEED = MOVESPEED * 3
var jumped = false
const MAX_JUMP_VELOCITY = -1000
const JUMP_VELOCITY = -1000
const JUMP_COYOTE_TIME = .07
const JUMP_FRICTION_COYOTE_TIME = .05
var timeSinceTouchingGround = 0
var timeTouchingGround = 0
var timeSinceLastJump = 0
const WALLJUMP_DELAY = .3 # seconds
const WALLJUMP_VELOCITY = JUMP_VELOCITY * 1.2
const WALLJUMP_HORIZONTAL_VELOCITY = -JUMP_VELOCITY * .4
var timeSinceTouchingWall = 0
const WALLJUMP_COYOTE_TIME = .2 # time off a wall until not able to jump
var holdingJump = false;
const WALLSLIDE_GRAV_FACTOR = .5
const MAX_WALLSLIDE_VELOCITY = 700
# todo make walls sticky rather than coyote time
var facing_direction = Vector2(1, 0)
var pressing_dir_x = false

const MAX_JUMP_BUFFER_TIME = .1
var timeSinceJumpBuffered = MAX_JUMP_BUFFER_TIME
var crouching = false

const MAX_HIT_STUN_TIME = .8
var timeSinceStunned = MAX_HIT_STUN_TIME

const MAX_WALL_VELOCITY_PRESERVATION_TIME = .1 # frames col with wall until kill speed TODO: implement
var timeTouchingWall = 0
var previousSpeed = Vector2(0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	timeSinceLastJump += delta
	timeSinceTouchingWall += delta
	timeSinceTouchingGround += delta
	timeTouchingGround += delta
	timeSinceJumpBuffered += delta
	timeSinceStunned += delta

	if timeTouchingWall == 0:
		if velocity.x != 0:
			previousSpeed = velocity
	elif timeTouchingWall < MAX_WALL_VELOCITY_PRESERVATION_TIME and not is_on_wall():
		velocity.x = previousSpeed.x

func _physics_process(delta):
	if Input.is_action_pressed("up"):
		facing_direction.y = -1
	elif Input.is_action_pressed("down"):
		facing_direction.y = 1
	else:
		facing_direction.y = 0
		
	var accel_fac = 0
	var decel_fac = 0

	# Add the gravity.
	if not is_on_floor():
		timeTouchingGround = 0
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
		timeSinceTouchingGround = 0
		if not holdingJump:
			jumped = false
		accel_fac = GROUND_ACCEL
		decel_fac = GROUND_DECEL

	if is_on_wall():
		timeSinceTouchingWall = 0
		timeTouchingWall += delta
	else:
		timeTouchingWall = 0

	# Handle jump. (periot)
	if Input.is_action_pressed("ui_accept") or timeSinceJumpBuffered < MAX_JUMP_BUFFER_TIME and not is_stunned():
		if not jumped and holdingJump:
			jump(JUMP_VELOCITY, delta)
			timeSinceJumpBuffered = MAX_JUMP_BUFFER_TIME
		elif timeSinceTouchingWall < WALLJUMP_COYOTE_TIME and timeSinceLastJump > WALLJUMP_DELAY and not is_on_floor():
			velocity.y = WALLJUMP_VELOCITY
			velocity.x += get_wall_normal().x * WALLJUMP_HORIZONTAL_VELOCITY
			timeSinceLastJump = 0
			timeSinceJumpBuffered = MAX_JUMP_BUFFER_TIME
			timeTouchingWall = 0
		elif not holdingJump and timeSinceJumpBuffered > MAX_JUMP_BUFFER_TIME: # if we're not jumping buffer it
			timeSinceJumpBuffered = 0
		if timeSinceTouchingGround < JUMP_COYOTE_TIME:
			holdingJump = true
	else:
		holdingJump = false
	
	# React if jump stops held
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= .5

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not is_stunned():
		var newXVel = velocity.x + direction * accel_fac
		# regular case, below and new gets clamped
		if clamp(velocity.x, -MAX_SPEED, MAX_SPEED) == velocity.x and clamp(newXVel, -MAX_SPEED, MAX_SPEED) != newXVel:
			velocity.x = clamp(newXVel, -MAX_SPEED, MAX_SPEED)
		# acceleration case below clamp
		elif clamp(newXVel, -MAX_SPEED, MAX_SPEED) == newXVel:
			velocity.x = newXVel
		# is new velocity closer to in bounds (against being over)
		elif velocity.x > MAX_SPEED and newXVel < velocity.x:
			velocity.x = newXVel
		elif velocity.x < -MAX_SPEED and newXVel > velocity.x:
			velocity.x = newXVel

		# only slow if coyote time has passed for easier chaining
		if clamp(velocity.x, -MAX_SPEED, MAX_SPEED) != velocity.x and timeTouchingGround > JUMP_FRICTION_COYOTE_TIME and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, decel_fac)

		facing_direction.x = direction
		pressing_dir_x = true
	else:
		pressing_dir_x = false
		velocity.x = move_toward(velocity.x, 0, decel_fac)

	move_and_slide()

func jump(force, jdelta):
	if velocity.y > 0:
		velocity.y = 0
	velocity.y += force - (gravity * jdelta) # cancel grav
	jumped = true
	timeSinceLastJump = 0

func hit(direction, force):
	velocity = direction * force
	timeSinceStunned = 0
	pass

func is_stunned():
	return timeSinceStunned < MAX_HIT_STUN_TIME
