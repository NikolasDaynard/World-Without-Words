extends Node2D

@onready var ui = $"../InteractionUi"
@onready var characterControlller = $"CharacterBody2D"

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			ui.summon_text("SPIKE YEAHHHH\n oh ma gawd", 
				characterControlller.global_position - Vector2(20, 20),
				characterControlller.facing_direction)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
