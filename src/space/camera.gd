extends Camera2D

signal cam_event

@export var min_zoom = 0.6
@export var max_zoom = 2.0

var dragging = false
var drag_start = Vector2.ZERO
@export var target:NodePath
@onready var target_node = get_node(target)
var follow_mode_on = false


func _input(event):
	if follow_mode_on:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start = event.position
				cam_event.emit()
			else:
				dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
	elif event is InputEventMouseMotion:
		if dragging:
			var drag_end = event.position
			var drag_distance = drag_start - drag_end
			position += drag_distance
			drag_start = drag_end

func start_follow():
	follow_mode_on = true
	

func end_follow():
	follow_mode_on = false
	

func _process(delta):
	if(follow_mode_on && target_node != null):
		position = target_node.position

func zoom_in():
	var new_zoom = zoom + Vector2(0.1, 0.1)
	if new_zoom.x < max_zoom:
		zoom = new_zoom
		# var tween = get_tree().create_tween()
		# tween.tween_property(self, "zoom", new_zoom, 0.2)


func zoom_out():
	var new_zoom = zoom - Vector2(0.1, 0.1)
	if new_zoom.x > min_zoom:
		zoom = new_zoom
		# var tween = get_tree().create_tween()
		# tween.tween_property(self, "zoom", new_zoom, 0.2)
