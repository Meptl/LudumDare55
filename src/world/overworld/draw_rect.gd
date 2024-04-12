extends Node2D

@export var highlight_color: Color
@export var highlight_duration: float = 0.1

var highlight_regions = {}


func highlight_region(region: Rect2):
	var i = 0
	while i in highlight_regions:
		i += 1
	highlight_regions[i] = region
	queue_redraw()
	await get_tree().create_timer(highlight_duration).timeout
	highlight_regions.erase(i)
	queue_redraw()


func _draw():
	for rect in highlight_regions.values():
		draw_rect(rect, highlight_color)
