extends Node2D
# these are all the things that are item locked, thus they are not in moveset

@onready var ui = $"../InteractionUi"
@onready var charController = $"CharacterBody2D"
@onready var sprite = $"CharacterBody2D/Sprite2D"
var MAX_DASH_TIME = .1
var timeSinceDash = MAX_DASH_TIME
var DASH_SPEED = 1400.0
var isVerticalDash = false
var verticalDashDir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceDash += delta
	if Input.is_action_just_pressed("attack"):
		ui.summon_text("SPIKE YEAHHHH\n oh ma gawd", 
			charController.global_position - Vector2(20, 20),
			charController.facing_direction.x,
			true)
	if Input.is_action_just_pressed("dash") and timeSinceDash > MAX_DASH_TIME and not charController.is_stunned():
		timeSinceDash = 0
		verticalDashDir = 0
	if timeSinceDash < MAX_DASH_TIME:
		var normalizedDir = charController.facing_direction.normalized()
		normalizedDir.y *= 1.7 # add y bias
		# properly handle just y no x
		if not charController.pressing_dir_x and (normalizedDir.y != 0 or verticalDashDir != 0):
			if normalizedDir.y != 0:
				charController.velocity.y = normalizedDir.y * DASH_SPEED
				verticalDashDir = normalizedDir.y
			elif verticalDashDir != 0:
				charController.velocity.y = verticalDashDir * DASH_SPEED
		else:
			verticalDashDir = 0
			charController.velocity = normalizedDir * DASH_SPEED
	# long dash (CHECK IF UNLOCKED)
	if Input.is_action_just_pressed("ui_accept"):
		if timeSinceDash < MAX_DASH_TIME and charController.timeSinceTouchingGround < charController.JUMP_COYOTE_TIME:
			charController.velocity.x -= 100.0 * charController.facing_direction.x
			# charController.jump(charController.JUMP_VELOCITY, delta)

	if charController.is_stunned():
		sprite.visible = int(charController.timeSinceStunned * 10) % 2
	else:
		sprite.visible = true
	pass
