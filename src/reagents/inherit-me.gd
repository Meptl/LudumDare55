extends Node

@export var reagent_name = "Placeholder Ingredient"
@export var cost = 5

@onready var path = $Path2D.curve
@onready var icon = $Icon.texture


func _ready():
	queue_free()
