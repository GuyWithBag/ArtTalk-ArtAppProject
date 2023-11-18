extends Node
class_name WorldEvent


@export var only_called_once: bool = true

var event_id: String:
	get:
		return name.to_snake_case()
var _event_has_been_called: bool = false


func call_event(called_by: Node) -> void:
	if _event_has_been_called == true:
		return
	_play_event(called_by)
	if only_called_once:
		_event_has_been_called = true


func _play_event(_played_by: Node) -> void:
	pass


func start_dialogue(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = [], title_variation: int = 0, pause_game: bool = true) -> void:
	UIManager.dialogue_balloon_manager.start(dialogue_resource, title, extra_game_states, title_variation, pause_game)
	await DialogueManager.dialogue_ended

