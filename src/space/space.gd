extends Node2D

signal cooked(creature, distance)

const COOK_THRESHOLD = 100

@export var failed_creation: PackedScene

@export var speed = 2.0
@export var path_scale = 2.0
@export var debug: Array[PackedScene]
@onready var goals = $Goals.get_children()
@onready var head = $Head
@onready var path_draw = $PathDraw

var sortedDictList

var failed_creature


func _ready():
	failed_creature = failed_creation.instantiate()
	failed_creature.visible = false
	add_child(failed_creature)
	# follow_reagents(debug)


func reset_head():
	head.position = Vector2(0, 0)
	path_draw.clear()


func follow_reagents(reagents_spec):
	path_draw.add_point(head.position)
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
			head.position = start_pos + path.sample_baked(traversed) * path_scale
			path_draw.add_point(head.position)
			queue_redraw()
			await get_tree().physics_frame


func cook():
	var closest_node = goals[0]
	var closest_dist = goals[0].position.distance_to(head.position)
	for goal in goals:
		var dist = goal.position.distance_to(head.position)
		if dist < closest_node.position.distance_to(head.position):
			closest_node = goal
			closest_dist = dist

	if closest_dist > COOK_THRESHOLD:
		cooked.emit(failed_creature, null)
	else:
		cooked.emit(closest_node, closest_dist)


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
		sorted_pairs.add_point([key, inputDictonary[key]])
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
