extends PanelContainer

@export var normal_style: StyleBox
@export var pressed_style: StyleBox
@export var hover_style: StyleBox

signal selected(reagent)

@export var reagent: PackedScene

@onready var icon_rect = $ReagentListing/TextureRect
@onready var name_label = $ReagentListing/Name
@onready var cost = $ReagentListing/Cost
@onready var path_container = $ReagentListing/Control
@onready var path = $ReagentListing/Control/Line2D


func _ready():
	self["theme_override_styles/panel"] = normal_style

	var info = reagent.instantiate()
	add_child(info)

	name_label.text = info.reagent_name
	cost.text = str(info.cost)
	icon_rect.texture = info.icon

	# TODO: manage scale.
	path.clear_points()
	for point in info.path.get_baked_points():
		path.add_point(point)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			self["theme_override_styles/panel"] = pressed_style
			selected.emit(reagent)
		else:
			self["theme_override_styles/panel"] = normal_style


func _on_mouse_entered():
	self["theme_override_styles/panel"] = hover_style


func _on_mouse_exited():
	self["theme_override_styles/panel"] = normal_style
