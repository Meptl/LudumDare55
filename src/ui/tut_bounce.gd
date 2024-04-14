extends Node2D

@export var dir = Vector2.UP
@export var size = 2.0


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir * size, 1.0)
	tween.chain().tween_property(self, "position", position, 1.0)
	tween.set_loops()
