extends CenterContainer

@onready var icon = %Icon
@onready var words = %Words
@onready var description = %Description
@onready var grade_label = %Grade


func popup():
	visible = true
	# await get_tree().create_timer(5).timeout
	# visible = false


func set_creature(creature, distance = null):
	icon.texture = creature.summon_icon
	words.text = creature.creature_name
	description.text = creature.description
	grade_label.text = grade(distance)


func grade(distance):
	if distance == null:
		var out = ["A", "B", "C", "D", "F"][randi_range(0, 4)]
		if randf() < 0.05:
			out = "S"
		return out

	# Note that the summoning circle is visually 40px radius.
	if distance < 5:
		return "SSS"
	elif distance < 10:
		return "SS"
	elif distance < 20:
		return "S"
	elif distance < 40:
		return "A"
	elif distance < 60:
		return "B"
	elif distance < 80:
		return "C"
	else:
		return "F"


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				visible = false
