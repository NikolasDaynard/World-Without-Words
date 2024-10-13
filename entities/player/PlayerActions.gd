extends Node2D

@onready var ui = $"../InteractionUi"
@onready var characterControlller = $"CharacterBody2D"
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
			characterControlller.global_position - Vector2(20, 20),
			characterControlller.facing_direction.x,
			true)
	if Input.is_action_just_pressed("dash"):
		print("fash")
		timeSinceDash = 0
		# properly handle just y no x
	if timeSinceDash < MAX_DASH_TIME:
		var normalizedDir = characterControlller.facing_direction.normalized()
		if not characterControlller.pressing_dir_x and normalizedDir.y != 0:
			characterControlller.velocity.y = normalizedDir.y * DASH_SPEED
		else:
			characterControlller.velocity = normalizedDir * DASH_SPEED
	pass
