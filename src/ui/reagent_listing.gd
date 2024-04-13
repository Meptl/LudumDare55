extends Button

signal selected(reagent)

@export var reagent: PackedScene

@onready var icon_rect = $ReagentListing/TextureRect
@onready var name_label = $ReagentListing/Name
@onready var cost = $ReagentListing/Cost
@onready var path = $ReagentListing/Control/Line2D


func _ready():
	var info = reagent.instantiate()
	add_child(info)

	name_label.text = info.reagent_name
	cost.text = str(info.cost)
	icon_rect.texture = info.icon

	# TODO: manage scale.
	path.clear_points()
	for point in info.path.get_baked_points():
		path.add_point(point)


func _on_pressed():
	selected.emit(reagent)
