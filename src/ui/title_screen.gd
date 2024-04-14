extends Control

signal play_game
signal exit_game

@onready var current_menu = %TitleMenu

@export_file("*.tscn") var game_scene: String


func switch_to_menu(menu: Node):
	current_menu.hide()
	current_menu = menu
	current_menu.show()


func _on_play_button_pressed():
	get_tree().change_scene_to_file(game_scene)


func _on_credits_pressed():
	switch_to_menu(%CreditsMenu)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	switch_to_menu(%TitleMenu)
