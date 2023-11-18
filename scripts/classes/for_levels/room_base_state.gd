extends BaseState
class_name RoomBaseState

@export var start_camera: GameCamera 
@export var transition_to_start_camera_duration: float

@onready var player: Player = PlayerManager.player
@onready var player_state_machine = player.state_machine


func enter() -> void: 
	if start_camera:
		CameraManager.transition_to_new_camera(start_camera, transition_to_start_camera_duration)
	
	
func exit() -> void: 
	pass


func start_dialogue(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = [], title_variation: int = 0, pause_game: bool = true) -> void:
	player_state_machine.disabled = true
	UIManager.dialogue_balloon_manager.start(dialogue_resource, title, extra_game_states, title_variation, pause_game)
	await DialogueManager.dialogue_ended
	
	
