# This script is for initializing the GameCamera's follow node. Connecting the screen_exited from the visibility notifier
# This is so that it transitions smoothly. 
extends Area2D


func _on_area_entered(area: Area2D) -> void: 
	if !(area.owner is GameCamera): 
		return
	var game_camera: GameCamera = area.owner 
	if game_camera.follow_node == owner: 
		game_camera.init()



