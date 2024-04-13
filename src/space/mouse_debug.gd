extends Node2D
@onready var goal1 = $RuneGreyTile001
@onready var goal2 = $RuneGreyTile003

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#print (get_local_mouse_position())
		get_node("Icon").position = get_local_mouse_position()
		print("Goal1 ",calcGoalDistance(goal1)," Goal2 ",calcGoalDistance(goal2))
		#calcGoalDistance(goal1)
		#calcGoalDistance(goal2)
		#drawLineBetween(goal1)
		#queue_redraw()

func calcGoalDistance(inputGoal):
	return get_node("Icon").position.distance_to(inputGoal.position)
	

#func drawLineBetween(inputGoal):
#	draw_line(get_node("Icon").position,inputGoal.position,Color.RED,5)

#func _draw():
#	drawLineBetween(goal1)
