extends Sprite2D

@onready var dialogue_window = $DialogueWindow
@onready var goal_icon = $DialogueWindow/Goal

var goal


func _ready():
	dialogue_window.scale = Vector2.ZERO
	var bounce = dialogue_window.position + Vector2(0, 30)
	var tween = get_tree().create_tween()
	tween.tween_property(
		dialogue_window, "position", dialogue_window.position + Vector2(0, -2), 1.0
	)
	tween.chain().tween_property(dialogue_window, "position", dialogue_window.position, 1.0)
	tween.set_loops()


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
