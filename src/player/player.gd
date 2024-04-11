extends CharacterBody2D

@export var MOTION_SPEED = 160  # Pixels/second.

@onready var cam = $Camera2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	cam.enabled = is_multiplayer_authority()


func _physics_process(_delta):
	if not is_multiplayer_authority():
		return

	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion = motion.normalized() * MOTION_SPEED
	set_velocity(motion)
	move_and_slide()

	# For some reason all other peers automatically sync except the host.
	if NakamaConnection.multiplayer.get_unique_id() == 1:
		update_remote_position.rpc(position)

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


@rpc("any_peer")
func update_remote_position(new_pos):
	position = new_pos
