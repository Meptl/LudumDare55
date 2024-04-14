extends Sprite2D

@onready var dialogue_window = $DialogueWindow
@onready var goal_icon = $DialogueWindow/Goal

var goal


func _ready():
	dialogue_window.scale = Vector2.ZERO


func new_goal(g):
	dialogue_window.scale = Vector2.ZERO
	await get_tree().create_timer(1).timeout
	goal = g
	goal_icon.texture = g.summon_icon
	speak()


func speak():
	dialogue_window.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(dialogue_window, "scale", Vector2.ONE, 0.2)
