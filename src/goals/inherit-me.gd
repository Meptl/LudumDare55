extends Node2D

@export var debug = true
@export var DEBUG_SIZE = 100

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
	queue_redraw()


func _process(delta):
	circle_glow.rotation += rotation_speed * delta
	if debug:
		queue_redraw()


func _draw():
	if debug:
		draw_arc(Vector2.ZERO, DEBUG_SIZE, 0, 2 * PI, 32, Color.RED)
