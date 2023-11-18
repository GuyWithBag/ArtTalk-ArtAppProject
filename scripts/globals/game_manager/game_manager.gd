# This Autoload is a Scene

extends Node

signal game_started
signal game_started_from_save_file(save_file: SaveFile)

const UNIT_SIZE: int = 32

var pausable: bool = true
var first_time_launched: bool

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_game() -> void: 
	LevelManager.start_chapter(LevelLoader.chapters[0])
	game_started.emit()
	
	
func start_game_from_save_file(save_file: SaveFile) -> void: 
	var _save_data = save_file.get_as_save_data()
	var current_scene: PackedScene = LevelManager.get_packed_scene_from_current_scene_path(save_file)
	LevelManager.change_room(
		current_scene, 
		_save_data
	)
	await RoomManager.room_is_ready
	SaveManager.loaded_data_from_file.emit(_save_data, save_file)
	game_started_from_save_file.emit(save_file)


func pause_game(value: bool) -> void: 
	if !pausable: 
		return
	get_tree().paused = value
	print("GameManager: Scene is paused: ", get_tree().paused)


func quit_game() -> void:
	get_tree().quit()


func save_data() -> Dictionary: 
	var data: Dictionary = {
		
	}
	return data

