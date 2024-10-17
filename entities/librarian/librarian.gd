extends Node2D

var ui
var player

var health = 100.0
var attackTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer = 4
	ui = get_node("/root/Scene/InteractionUi")
	player = get_node("/root/Scene/Player/CharacterBody2D")

	# instantiate arc
	
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attackTimer += delta
	if attackTimer > 10:
		attackTimer = 0
		health = -1
		ui.summon_text("SPIKE YEAHHHH\n oh ma gawd", 
			global_position + Vector2(70, 70),
			(player.global_position - global_position).normalized().x,
			false)

	pass

func is_alive() -> bool:
	return health > 0
