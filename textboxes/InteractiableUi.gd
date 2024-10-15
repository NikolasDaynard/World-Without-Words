extends Node2D

var spikeText = preload("res://textboxes/SpikeTextbox.tscn")
var fireballText = preload("res://textboxes/FireballTextbox.tscn")
var lastSummonedText

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func summon_text(text, new_position, direction_vector, friendly_to_player):
	if not direction_vector is Vector2:
		direction_vector = Vector2(direction_vector, 0)
	var text_is_finished = false
	if lastSummonedText:
		if is_instance_valid(lastSummonedText):
			if lastSummonedText.is_finished():
				text_is_finished = lastSummonedText.is_finished()
		else:
			text_is_finished = true # don't try to free already freed
	else:
		text_is_finished = true
	if !text_is_finished: # can't cast 2 things at the same time
		lastSummonedText.queue_free()

	var newText = fireballText.instantiate()
	lastSummonedText = newText
	add_child(newText)
	newText.set_friendly_to_player(friendly_to_player)
	newText.add_text(text)
	newText.direction_vector = direction_vector
	newText.global_position = new_position
	pass

