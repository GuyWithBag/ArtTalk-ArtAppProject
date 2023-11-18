extends Node

signal found_player(player: Player)

var player: Player: 
	get: 
		var _player: Player = get_tree().get_first_node_in_group("Player")
		if is_instance_valid(_player): 
			found_player.emit(_player)
			return _player
		printerr("Error: Cannot find player in this scene: ", LevelManager.current_scene)
		return null
		
var death_count: int = 0
var debug: bool = false 


func init() -> void: 
#	UIManager.mobile_controls.init()
	pass
	
	
func save_data() -> Dictionary:
	var data: Dictionary = {}
	data.merge(player.save_data(), true)
	return data
	
	
func load_data(data: Dictionary) -> void: 
	player.load_data(data)
	
	
