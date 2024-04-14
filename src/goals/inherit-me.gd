extends Node2D

@export var creature_name = "Creature"
@export_multiline var description = ""
@export var circles: Array[Texture]
@export var rotation_min = 0.05
@export var rotation_max = 0.15
@export var show_summon_circle = true

@onready var circle_glow = $Circle
@onready var circle_sprite = $Circle/Circle2

@onready var summon_icon = $SummonIcon.texture
@onready var rotation_speed = randf_range(rotation_min, rotation_max)


func _ready():
	var i = randi() % circles.size()
	circle_glow.texture = circles[i]
	circle_sprite.texture = circles[i]


func _process(delta):
	circle_glow.rotation += rotation_speed * delta
