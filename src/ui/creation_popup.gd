extends CenterContainer

@onready var icon = %Icon
@onready var words = %Words


func popup():
	visible = true
	# await get_tree().create_timer(5).timeout
	# visible = false


func set_creature(image, name):
	icon.texture = image
	words.text = name


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				visible = false
