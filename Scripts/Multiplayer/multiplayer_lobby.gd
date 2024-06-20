extends Node
class_name MultiplayerLobby

@export var level_scene: PackedScene
@onready var level_container: Node = $Level
@onready var ip_line_edit: LineEdit = $Multiplayer/PanelContainer/MarginContainer/HBoxContainer/IPLineEdit
@onready var lobby_ui: CanvasLayer = $Multiplayer

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_player_connected)
	
	if GameManager.host_mode:
		_host()
	
func _host() -> void:
	Lobby.create_game()
	hide_menu.rpc()
	change_level(level_scene)

func _on_connect_pressed() -> void:
	Lobby.join_game(ip_line_edit.text)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")


func change_level(scene):
	for c in level_container.get_children():
		level_container.remove_child(c)
		c.queue_free()
	level_container.add_child(scene.instantiate())

func _on_connection_failed():
	$Multiplayer/ErrorPrompt.visible = true

func _on_connected_to_server():
	hide_menu.rpc()
	change_level(level_scene)
	
func _on_player_connected(id):
	pass
	
@rpc("any_peer", "call_local", "reliable")
func hide_menu():
	lobby_ui.hide()
