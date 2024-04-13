extends Player

@export var MOTION_SPEED = 40  # Pixels/second.

var move_dst = Vector2.ZERO


func _physics_process(delta):
	super(delta)
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion = motion.normalized() * MOTION_SPEED
	set_velocity(motion)
	move_and_slide()
