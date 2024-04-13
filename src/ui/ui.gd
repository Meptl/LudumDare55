extends Control

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool
@onready var space = %Space
@onready var closeness_label = %ClosenessToCreature


func _ready():
	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)


func _on_CookButton_pressed():
	var spec = []
	for reagent in summon_pool.reagents:
		var r = reagent[0]
		var amount = reagent[1].amount()
		spec.append([r, amount])
	await space.follow_reagents(spec)
	closeness_label.text = "Creature%: " + str(space.getTopTile())
