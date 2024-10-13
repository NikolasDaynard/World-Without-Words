extends Node2D

@onready var ui = $"../InteractionUi"
@onready var charController = $"CharacterBody2D"
var MAX_DASH_TIME = .1
var timeSinceDash = MAX_DASH_TIME
var DASH_SPEED = 1400.0

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
	if Input.is_action_just_pressed("dash"):
		print("fash")
		timeSinceDash = 0
		# properly handle just y no x
	if timeSinceDash < MAX_DASH_TIME:
		var normalizedDir = charController.facing_direction.normalized()
		if not charController.pressing_dir_x and normalizedDir.y != 0:
			charController.velocity.y = normalizedDir.y * DASH_SPEED
		else:
			charController.velocity = normalizedDir * DASH_SPEED
	# long dash (CHECK IF UNLOCKED)
	if Input.is_action_just_pressed("ui_accept"):
		if timeSinceDash < MAX_DASH_TIME and charController.timeSinceTouchingGround < charController.JUMP_COYOTE_TIME:
			charController.velocity.x -= 100.0 * charController.facing_direction.x
			print("ldash")
	pass
