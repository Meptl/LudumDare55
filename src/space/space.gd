extends Node2D

@export var speed = 2.0
@export var pre: Array[PackedScene]

@onready var cam = $Camera2D
@onready var icon = $Icon

var dragging = false
var drag_start = Vector2.ZERO

var hist = []

# func _ready():
# 	follow_reagents(pre)


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


func follow_reagents(reagents):
	hist.append(icon.position)
	for r in reagents:
		var info = r.instantiate()
		add_child(info)

		var start_pos = icon.position
		for point in info.path.get_baked_points():
			icon.position = start_pos + point
			hist.append(icon.position)
			queue_redraw()
			await get_tree().physics_frame


func _draw():
	for i in range(1, hist.size()):
		draw_line(hist[i - 1], hist[i], Color.WHITE, 2)
