extends Node

@export var reagent_name = "Reagent"
@export var cost = 5

@onready var path = $Path2D.curve
@onready var icon = $Icon.texture


# TODO: Bake path info. For now you must extract all required info on frame of
# creation.
func _ready():
	queue_free()
