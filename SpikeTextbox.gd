extends Node2D

@onready var label = self.get_node("Label")
@onready var background = self.get_node("Sprite2D")
@onready var font = label.get("theme_override_fonts/font")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_global_mouse_position()
	global_position = lerp(global_position, mousePos, delta)
	pass
	
func add_text(text):
	label.set_text(text)
	var textSize = font.get_multiline_string_size(text)

	var desired_size = textSize  # The desired size in pixels
	var texture_size = background.texture.get_size()  # Get the original size of the texture

	var scale_factor = desired_size / texture_size  # Calculate the scaling factor
	background.scale = scale_factor  # Apply the scale to resize the sprite

	# Position the background to center it
	background.global_position = label.global_position + (background.texture.get_size() * background.scale / 2)

	background.scale += Vector2(.5, .5) # add some border
	label.global_position -= textSize / 2  # Center the label
	background.global_position -= textSize / 2  # Center the label

	pass
