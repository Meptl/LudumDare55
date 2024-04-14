extends Node2D

signal cooked(creature)

@export var failed_creation: PackedScene

@export var speed = 2.0
@export var debug: Array[PackedScene]
@onready var goals = $Goals.get_children()
@onready var cam = $Camera2D
@onready var head = $Head

var sortedDictList
var dragging = false
var drag_start = Vector2.ZERO

var hist = []
var failed_creature


func _ready():
	failed_creature = failed_creation.instantiate()
	failed_creature.visible = false
	add_child(failed_creature)
	# follow_reagents(debug)


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


func reset_head():
	head.position = Vector2(0, 0)
	hist = []


func follow_reagents(reagents_spec):
	hist.append(head.position)
	print(reagents_spec)
	for spec in reagents_spec:
		var reagent = spec[0]
		var amount = spec[1]
		var info = reagent.instantiate()
		add_child(info)

		print(info.reagent_name, ": ", amount * 100, "%")

		var start_pos = head.position
		var path = info.path
		var travel = path.get_baked_length() * amount
		var traversed = 0
		while traversed <= travel:
			# TODO: Move the actual movement to _process.
			traversed += 1
			head.position = start_pos + path.sample_baked(traversed)
			hist.append(head.position)
			queue_redraw()
			await get_tree().physics_frame


func cook():
	sortedDictList = sortTilesByDistance(makeTileDistanceList())
	if getTopTile() < 30:
		cooked.emit(failed_creature)
	else:
		cooked.emit(sortedDictList.keys()[0])


func _draw():
	for i in range(1, hist.size()):
		draw_line(hist[i - 1], hist[i], Color.WHITE, 2)


func calcGoalDistance(inputGoal):
	return head.position.distance_to(inputGoal.position)


#get a list of distances betweent he node and tiles
func makeTileDistanceList():
	var unsortedDictonary = {}
	for element in goals:
		var tempDis = calcGoalDistance(element)
		if tempDis < 300:
			unsortedDictonary[element] = tempDis
	print("Unsorted Dict: ", unsortedDictonary)
	return unsortedDictonary


#Given a dictonary of nodes where each node has a distance assigned, sort by distnace
func sortTilesByDistance(inputDictonary):
	var sorted_pairs = []
	for key in inputDictonary.keys():
		sorted_pairs.append([key, inputDictonary[key]])
	sorted_pairs.sort()
	var sorted_dictionary = {}
	for pair in sorted_pairs:
		sorted_dictionary[pair[0]] = pair[1]
	return sorted_dictionary


#Get the top N tiles from a given dictonary, and assign them percentages
func getTopTile():
	if sortedDictList == null:
		return "0"
	var closestNode = sortedDictList.keys()[0]
	var distance = sortedDictList.values()[0]
	var creaturePercent = ((300 - distance) / 300) * 100
	print("Closest Tile:", closestNode, "Percentage: ", creaturePercent)
	return creaturePercent
