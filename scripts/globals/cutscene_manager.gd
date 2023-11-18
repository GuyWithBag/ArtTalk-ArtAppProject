extends Node

var current_cutscene: String # cutscene_player.current_animation
var cutscene_player: AnimationPlayer


func init(_cutscene_player: AnimationPlayer) -> void: 
	if !is_instance_valid(_cutscene_player): 
		printerr("CutsceneManager: CutscenePlayer is Missing")
		return
	cutscene_player = _cutscene_player


#func set_dialogue_container_active(value: bool) -> void:
#	if value == true: 
#		cutscene_player.pause()
#		cutscene_player.seek(cutscene_player.current_animation_position + 0.1)
#	else: 
#		cutscene_player.play()
#	UIManager.dialogue_balloon_manager.set_dialogue_container_active(value)
#
#
