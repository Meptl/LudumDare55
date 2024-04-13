extends Node2D

@onready var cam = $Camera2D

var dragging = false
var drag_start = Vector2.ZERO


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start = event.position
			else:
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			var drag_end = event.position
			var drag_distance = drag_start - drag_end
			cam.position += drag_distance
			drag_start = drag_end
