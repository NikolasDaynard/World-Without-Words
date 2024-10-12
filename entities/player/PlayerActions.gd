extends Node2D

@onready var ui = $"../InteractionUi"
@onready var characterControlller = $"CharacterBody2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		ui.summon_text("SPIKE YEAHHHH\n oh ma gawd", 
			characterControlller.global_position - Vector2(20, 20),
			characterControlller.facing_direction,
			true)
	pass
