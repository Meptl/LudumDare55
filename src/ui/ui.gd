extends Control

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool
@onready var space = %Space
@onready var closeness_label = %ClosenessToCreature
@onready var creation_popup = %CreationPopup
@onready var goalman = %GoalMan


func _ready():
	randomize()
	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)
	space.cooked.connect(on_cooked)

	await get_tree().create_timer(4).timeout
	new_goal()


func new_goal():
	var new_goal = space.goals[randi_range(0, space.goals.size() - 1)]
	goalman.new_goal(new_goal)


func on_cooked(creature, distance):
	creation_popup.set_creature(creature, distance)
	creation_popup.popup()

	if goalman.goal != null and creature.name == goalman.goal.creature_name:
		new_goal()


func _on_CookButton_pressed():
	var spec = []
	for reagent in summon_pool.reagents:
		var r = reagent[0]
		var amount = reagent[1].amount()
		spec.append([r, amount])
	await space.follow_reagents(spec)
	space.cook()
	space.reset_head()
	closeness_label.text = "Creature%: " + str(space.getTopTile())
