extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func summon_text(text):
	var newText = preload("res://SpikeTextbox.tscn").instantiate()
	add_child(newText)
	newText.add_text(text)

