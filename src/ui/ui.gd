extends Control

@onready var reagent_table = %ReagentTable
@onready var summon_pool = %SummonPool


func _ready():
	for child in reagent_table.get_children():
		child.selected.connect(summon_pool.add_reagent)
