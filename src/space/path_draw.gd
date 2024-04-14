extends Node2D

@export var color = Color.WHITE
@export var max_width = 5
@export var min_width = 1
@export var min_dist = 30

var hist = []


func add_point(value):
	hist.append(value)
	queue_redraw()


func clear():
	hist.clear()
	queue_redraw()


func _draw():
	var middle = hist.size() / 2
	for i in range(1, hist.size()):
		var width = max_width - (max_width - min_width) * abs(middle - i) / middle
		draw_line(hist[i - 1], hist[i], color, width)
