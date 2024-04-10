extends Node2D

@export var player_scene = preload("res://src/player/player.tscn")


func _on_host_pressed():
	await init_nakama()
	await NakamaConnection.multiplayer_bridge.create_match()
	# $Join.hide()
	# $Host.hide()


func _on_join_pressed():
	await init_nakama()
	await NakamaConnection.multiplayer_bridge.join_match($LineEdit.text)
	# $Join.hide()
	# $Host.hide()


# Called by child player node.
func exit_game(id):
	del_player(id)


func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
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
	get_node(str(id)).queue_free()


func _on_match_joined() -> void:
	print("Joined match: ", NakamaConnection.multiplayer_bridge.match_id)
	add_player(NakamaConnection.multiplayer.get_unique_id())
