extends CharacterBody2D
class_name Player

@export var local = true

@onready var cam = $Camera2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	cam.enabled = local or is_multiplayer_authority()


func _physics_process(_delta):
	if not local && not is_multiplayer_authority():
		return

	# For some reason all other peers automatically sync except the host.
	if NakamaConnection.multiplayer.get_unique_id() == 1:
		update_remote_position.rpc(position)


@rpc("any_peer")
func update_remote_position(new_pos):
	position = new_pos
