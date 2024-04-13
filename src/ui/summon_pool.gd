extends HBoxContainer

@export var pre: Array[PackedScene]

var reagents = []


func _ready():
	for r in pre:
		add_reagent(r)


func add_reagent(reagent):
	var info = reagent.instantiate()
	add_child(info)

	var texture_button = TextureButton.new()
	texture_button.texture_normal = info.icon
	add_child(texture_button)

	texture_button.pressed.connect(remove_reagent.bind(texture_button))
	reagents.append(reagent)


func remove_reagent(src):
	var i = 0
	for child in get_children():
		if child == src:
			break
	reagents.remove_at(i)
	src.queue_free()
