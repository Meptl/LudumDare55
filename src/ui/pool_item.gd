extends TextureButton

signal remove_requested(src)

@onready var darken = $Darken
@onready var percentage = $Percentage

var charge_max = 3.0
var charge = 0.0
var charging = false


func amount():
	return clamp(charge / charge_max, 0, 1.0)


func _process(_delta):
	percentage.text = str(int(amount() * 100)) + "%"


func _physics_process(delta):
	if not charging:
		return
	charge += delta
	# 1.0 is darkened. 0.0 is done.
	darken.material.set_shader_parameter(
		"EdgePosition", clampf((charge_max - charge) / charge_max, 0.0, 1.0)
	)


func _on_button_down():
	charging = true


func _on_button_up():
	charging = false


func _on_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				charging = event.pressed
			MOUSE_BUTTON_RIGHT:
				remove_requested.emit(self)