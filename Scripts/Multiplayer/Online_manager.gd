extends Node

var players_in_game: Array[OnlinePlayer] = []
var pos: Vector3

func set_starting_positions():
	for player in get_tree().get_nodes_in_group("player"):
		players_in_game.append(player)
	for n in players_in_game:
		if n.player_id == 1:
			pos = n.global_position
		elif n.player_id == 2:
			pos = n.global_position
