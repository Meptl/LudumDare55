extends HBoxContainer

@export var pool_item_scene: PackedScene
@export var pre: Array[PackedScene]

var reagents = []


func _ready():
	for r in pre:
		add_reagent(r)


func add_reagent(reagent):
	var info = reagent.instantiate()
	add_child(info)

	var pool_item = pool_item_scene.instantiate()
	pool_item.texture_normal = info.icon
	add_child(pool_item)
	pool_item.remove_requested.connect(remove_reagent)
	reagents.append([reagent, pool_item])


func remove_reagent(src):
	var i = 0
	for child in get_children():
		if child == src:
			break
		i += 1
	reagents.remove_at(i)
	src.queue_free()
