extends Control

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool
@onready var space = %Space
@onready var closeness_label = %ClosenessToCreature
@onready var creation_popup = %CreationPopup


func _ready():
	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)
	space.cooked.connect(on_cooked)


func on_cooked(creature):
	creation_popup.set_creature(creature)
	creation_popup.popup()


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
