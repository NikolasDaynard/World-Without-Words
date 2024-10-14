extends Node2D
# these are all the things that are item locked, thus they are not in moveset

@onready var ui = $"../InteractionUi"
@onready var charController = $"CharacterBody2D"
@onready var sprite = $"CharacterBody2D/Sprite2D"
@onready var lanceSprite = $"CharacterBody2D/lance/Sprite2D"
@onready var lanceControl = $"CharacterBody2D/lance"
const DASH_SPEED = 1200.0
const MAX_DASH_TIME = .15
var timeSinceDash = MAX_DASH_TIME
var isVerticalDash = false
var verticalDashDir = 0
var dashesUsed = 0
const MAX_DASHES = 1

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
	if charController.is_on_floor():
		dashesUsed = 0
		lanceSprite.visible = false

	if Input.is_action_just_pressed("dash") and timeSinceDash > MAX_DASH_TIME and not charController.is_stunned() and dashesUsed < MAX_DASHES:
		timeSinceDash = 0
		verticalDashDir = 0
		dashesUsed += 1
		lanceSprite.visible = true

	if timeSinceDash < MAX_DASH_TIME:
		var normalizedDir = charController.facing_direction.normalized()
		# properly handle just y no x
		if not charController.pressing_dir_x and (normalizedDir.y != 0 or verticalDashDir != 0):
			if normalizedDir.y != 0:
				charController.velocity.y = normalizedDir.y * DASH_SPEED
				verticalDashDir = normalizedDir.y
			elif verticalDashDir != 0:
				charController.velocity.y = verticalDashDir * DASH_SPEED
		else:
			if normalizedDir.y != 0:
				verticalDashDir = normalizedDir.y
			charController.velocity = Vector2(normalizedDir.x, verticalDashDir) * DASH_SPEED
		lanceSprite.rotation = charController.velocity.angle()
		lanceControl.position = charController.velocity / 10.0
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
