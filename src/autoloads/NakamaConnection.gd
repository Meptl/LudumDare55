extends Node

const SCHEME = "http"
const IP_ADDRESS = "64.176.216.144"
const PORT = 7350
const SERVER_KEY = "defaultkey"

var client
var session
var multiplayer_bridge


func init_nakama():
	if client:
		# TODO: Check if session is still valid and refresh it.
		return

	client = Nakama.create_client(
		SERVER_KEY, IP_ADDRESS, PORT, SCHEME, Nakama.DEFAULT_TIMEOUT, NakamaLogger.LOG_LEVEL.ERROR
	)

	# Get the System's unique device identifier
	var device_id = OS.get_unique_id()

	# Authenticate with the Nakama server using Device Authentication
	session = await client.authenticate_device_async(device_id)
	if session.is_exception():
		printerr("Failed to create session: ", session)
		return

	var socket = Nakama.create_socket_from(client)
	socket.received_error.connect(self._on_socket_error)
	await socket.connect_async(session)

	multiplayer_bridge = NakamaMultiplayerBridge.new(socket)
	multiplayer_bridge.match_join_error.connect(_on_match_join_error)
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer


func _on_socket_error(err):
	printerr("Socket error: ", err)


func _on_match_join_error(err):
	printerr("Unable to join match: ", err.message)
