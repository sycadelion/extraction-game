extends Node3D

@export var players_container: Node3D
@export var player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner

var player_count = 0

func _enter_tree() -> void:
	player_spawner.spawn_function = spawn_player

func _ready() -> void:
	player_count = 0
	
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.connect(delete_player)
	multiplayer.peer_connected.connect(player_joined)
	
	add_player(1)
	
	for id in multiplayer.get_peers():
		add_player(id)
		

func spawn_player(id):
	var player_instance = player_scene.instantiate()
	print("player " + str(player_count) + " Spawned")
	
	#set player id
	if id == 1:
		player_instance.player_id = 1
		
	else:
		player_instance.player_id = 2
	
	#set player to spawn position
	player_instance.name = str(id)
	player_instance.position = Vector3(0,1,0)
	return player_instance

func add_player(id):
	player_count += 1
	player_spawner.spawn(id)

func player_joined(id):
	add_player(id)

func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_disconnected.disconnect(delete_player)
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	
	players_container.get_node(str(id)).queue_free()
