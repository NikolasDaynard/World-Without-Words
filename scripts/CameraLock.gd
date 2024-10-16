extends Area2D

@export var endLock: Node2D
var locked_camera: bool = false
var cameraRef: Camera2D
var playerRef: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if endLock.has_method("is_alive"):
		if not endLock.is_alive():
			if locked_camera:
				locked_camera = false
				cameraRef.global_position = playerRef.global_position
			cameraRef = null
	if locked_camera and cameraRef is Camera2D:
		cameraRef.global_position = global_position
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("Camera2D").global_position = global_position
		locked_camera = true
		cameraRef = body.get_node("Camera2D")
		playerRef = body
	pass # Replace with function body.
