extends Control

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool
@onready var space = %Space


func _ready():
	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)


func _on_CookButton_pressed():
	space.follow_reagents(summon_pool.reagents)
