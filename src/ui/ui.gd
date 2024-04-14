extends Control

const reagents_path = "res://src/reagents/"
const reagent_listing = preload("res://src/ui/reagent_listing.tscn")

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool
@onready var space = %Space
@onready var creation_popup = %CreationPopup
@onready var goalman = %GoalMan
@onready var cook_button = %CookButton
@onready var tuts = [%Tut1, %Tut2, %Tut3]
@onready var music = $Music

var goalman_popped = false


func _ready():
	randomize()
	init_reagent_table()
	space.cooked.connect(on_cooked)
	summon_pool.charge_start.connect(on_charge_start)
	summon_pool.remove_requested.connect(on_reagent_remove)

	for tut in tuts:
		tut.visible = false
	tuts[0].visible = true

	cook_button.disabled = summon_pool.reagents.size() == 0
	goalman.position.y += 300


func init_reagent_table():
	for child in reagent_table.get_children():
		child.queue_free()

	var dir = DirAccess.open(reagents_path)
	var file_names = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (
				not dir.current_is_dir()
				and file_name.ends_with(".tscn")
				and file_name != "inherit-me.tscn"
			):
				file_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	file_names.sort()

	for file_name in file_names:
		var node = reagent_listing.instantiate()
		node.reagent = load(reagents_path + file_name)
		reagent_table.add_child(node)

	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)
		child.selected.connect(on_reagent_add)


func new_goal():
	if not goalman_popped:
		goalman_popped = true
		var tween = get_tree().create_tween()
		tween.tween_property(goalman, "position", goalman.position + Vector2(0, -300), 1.0)
	var new_goal = space.goals[randi_range(0, space.goals.size() - 1)]
	goalman.new_goal(new_goal)


func on_charge_start():
	if tuts[1].visible:
		tuts[2].visible = true


func on_reagent_remove():
	cook_button.disabled = summon_pool.reagents.size() == 0


func on_reagent_add(reagent):
	cook_button.disabled = false
	if tuts[0].visible:
		tuts[0].visible = false
		tuts[1].visible = true


func on_cooked(creature, distance):
	creation_popup.set_creature(creature, distance)
	creation_popup.popup()

	if goalman.goal != null and creature.creature_name == goalman.goal.creature_name:
		new_goal()


func _on_CookButton_pressed():
	cook_button.disabled = true
	var tut_was_on = tuts[2].visible
	if tuts[2].visible:
		tuts[1].visible = false
		tuts[2].visible = false

	space.reset_head()

	var spec = []
	for reagent in summon_pool.reagents:
		var r = reagent[0]
		var amount = reagent[1].amount()
		spec.append([r, amount])
	await space.follow_reagents(spec)

	space.cook()

	if tut_was_on:
		new_goal()

	cook_button.disabled = false
