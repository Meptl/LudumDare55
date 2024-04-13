extends Node2D

@export var speed = 0.05


func _process(delta):
	rotation = rotation + speed * delta
