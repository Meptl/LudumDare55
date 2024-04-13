extends Node2D
@onready var goalList =[$RuneGreyTile001,$RuneGreyTile002,$RuneGreyTile003] 
var sortedDictList

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_node("Icon").position = get_local_mouse_position()
		sortedDictList = sortTilesByDistance(makeTileDistanceList())
		getTopTile()
		print("End Loop")
#caclulate the distance between this item and another node
func calcGoalDistance(inputGoal):
	return get_node("Icon").position.distance_to(inputGoal.position)
#get a list of distances betweent he node and tiles
func makeTileDistanceList():
	var unsortedDictonary = {}
	for element in goalList:
			var tempDis = calcGoalDistance(element)
			if tempDis < 500:
				unsortedDictonary[element] = tempDis
	print("Unsorted Dict: ",unsortedDictonary)
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
	var closestNode = sortedDictList.keys()[0]
	var distance = sortedDictList.values()[0]
	var creaturePercent = ((500-distance)/500)*100
	print("Closest Tile:",closestNode,"Percentage: ", creaturePercent)
	pass
#Get the top N tiles from a given dictonary, and assign them percentages
func getTopNTiles(topCount,sortedDict):
	pass

