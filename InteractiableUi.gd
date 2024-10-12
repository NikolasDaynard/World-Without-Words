extends Node2D

var spikeText = preload("res://SpikeTextbox.tscn")
var fireballText = preload("res://FireballTextbox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func summon_text(text, new_position, direction_vector):
	var newText = fireballText.instantiate()
	add_child(newText)
	newText.add_text(text)
	newText.direction_vector.x = direction_vector
	newText.global_position = new_position

