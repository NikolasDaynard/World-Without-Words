extends Node2D

@onready var label = self.get_node("TextureRect/Label")
@onready var textRect = self.get_node("TextureRect")
@onready var background = self.get_node("Sprite2D")
@onready var font = label.get("theme_override_fonts/font")

var direction_vector = Vector2(0, 0)
const UI_TRAVEL_VELOCITY = 700.0
var timeAlive = 0
const UI_MOVEMENT_DELAY = 1 # time till it starts moving
var text = "Fire"
var text_rotation;
var is_player_friendly = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_text("Fire")
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeAlive += delta
	# var mousePos = get_global_mouse_position()
	# global_position = lerp(global_position, mousePos, delta)
	if timeAlive > UI_MOVEMENT_DELAY:
		global_position += direction_vector * delta * UI_TRAVEL_VELOCITY
	else:
		# typewriter effect, probably terribly slow but whatever
		var visible_chars = ""
		for i in text.length():
			if (float(i) / text.length()) <= (timeAlive / UI_MOVEMENT_DELAY):
				visible_chars += text[i]
			else:
				break
		label.set_text(visible_chars)
		
	pass
	
func add_text(new_text):
	text = new_text
	for i in 10:
		for j in 10:
			text += " " + new_text
		text += "\n"
	var textSize = font.get_multiline_string_size(new_text)

	var desired_size = textSize  # The desired size in pixels
	var texture_size = background.texture.get_size()  # Get the original size of the texture

	var scale_factor = desired_size / texture_size  # Calculate the scaling factor
	background.scale = scale_factor  # Apply the scale to resize the sprite

	# Position the background to center it
	background.global_position = textRect.global_position + (background.texture.get_size() * background.scale / 2)

	background.scale += Vector2(.5, .5) # add some border
	textRect.scale = background.scale
	background.global_position -= textSize / 2  # Center the label
	textRect.global_position -= background.global_position

	label.rotation = -45
	label.position.y += texture_size.y / 4
	label.position.x -= texture_size.x / 4

	pass

func is_finished(): # returns true when finished speaking
	return timeAlive > UI_MOVEMENT_DELAY

func set_friendly_to_player(friendly: bool):
	is_player_friendly = friendly
	pass

func _on_area_2d_body_entered(body):
	# print(body)
	if not is_player_friendly and body.has_method("hit"):
		body.hit(body.global_position - global_position, 10.0)
	pass # Replace with function body.


func _on_area_2d_area_entered(area): # should be enemy
	# print(area)
	if area.has_method("apply_force"):
		area.apply_force(area.global_position - global_position, 1)
		queue_free()
	pass # Replace with function body.
