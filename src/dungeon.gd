extends Node2D

@export var player_scene = preload("res://src/player/player.tscn")


func _on_host_pressed():
	await init_nakama()
	await NakamaConnection.multiplayer_bridge.create_match()
	$Join.hide()
	$Host.hide()


func _on_join_pressed():
	await init_nakama()
	await NakamaConnection.multiplayer_bridge.join_match($LineEdit.text)
	$Join.hide()
	$Host.hide()


func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	# Unneeded if we have specific spawn points, but if we have a single spawn
	# location there exists a single frame of collision that occurs between this
	# node and peers (before the peer updates their position). This causes
	# move_and_slide to behave buggy and persist when the peer updates its
	# position. Note that this does not solve the issue of a node authoritatively
	# sitting on the spawn point.
	if peer_id != NakamaConnection.multiplayer.get_unique_id():
		player.position = Vector2(-5000, 5000)
	add_child(player)


func del_player(id):
	rpc("_del_player", id)


func _on_peer_connected(peer_id):
	print("Peer joined match: ", peer_id)
	add_player(peer_id)


func _on_peer_disconnected(peer_id):
	print("Peer left match: ", peer_id)
	del_player(peer_id)


func init_nakama():
	await NakamaConnection.init_nakama()
	NakamaConnection.multiplayer_bridge.match_joined.connect(_on_match_joined)
	NakamaConnection.multiplayer.peer_connected.connect(_on_peer_connected)
	NakamaConnection.multiplayer.peer_disconnected.connect(_on_peer_disconnected)


@rpc("any_peer", "call_local")
func _del_player(id):
	var node = get_node(str(id))
	if node:
		node.queue_free()


func _on_match_joined() -> void:
	print("Joined match: ", NakamaConnection.multiplayer_bridge.match_id)
	add_player(NakamaConnection.multiplayer.get_unique_id())
