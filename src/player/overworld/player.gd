extends Player

@export var MOTION_SPEED = 40  # Pixels/second.

var move_dst = Vector2.ZERO


func _physics_process(delta):
	super(delta)

	if move_dst == Vector2.ZERO:
		return

	if position.distance_to(move_dst) < 4:
		move_dst = Vector2.ZERO

	var dir = position.direction_to(move_dst)
	set_velocity(dir * MOTION_SPEED)
	move_and_slide()


func _input(event):
	if not local && not is_multiplayer_authority():
		return

	# Move to mouse click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		move_dst = get_parent().get_local_mouse_position()
