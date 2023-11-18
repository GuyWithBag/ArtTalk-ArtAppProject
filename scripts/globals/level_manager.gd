extends Node

signal root_scene_changed()

var current_chapter: LevelChapterResource:
	get:
		if current_scene.chapter_id == 1: 
			return LevelLoader.chapters[0]
		return LevelLoader.chapters[current_scene.chapter_id]
		
var current_level: LevelResource: 
	get: 
		return current_chapter.levels[current_scene.level_id]
		
var current_stage: LevelStageResource:
	get:
		return current_level.stages[current_scene.stage_id]
		
var current_room: LevelRoomResource:
	get:
		return current_stage.rooms[current_scene.room_id] 

var current_scene_path: String: 
	get: 
		var path: String = "%s/%s/%s/%s" % [current_scene.chapter_id, current_scene.level_id, current_scene.stage_id, current_scene.room_id]
		return path 

# W.I.P. 
var levels_passed

var _load_data: SaveData
var rooms_in_level: Array[PackedScene]

var scenes_history: Array[PackedScene]

@onready var current_scene: Node:
	get:
		return get_tree().current_scene
		
# ToDo: 
# - Fix current_scene to actually reflect the current_scene

func _ready() -> void: 
	RoomManager.room_is_ready.connect(_on_room_is_ready)


func next_chapter() -> void:
	var next_index: int = current_scene.chapter_id + 1
	if next_index > LevelLoader.chapters.size() - 1: 
		printerr("LevelManager: \n Current Chapter ID is %s \n Max Chapters: %s \n Cannot next chapter because there is no more next chapter. " % [current_room.chapter_id, LevelLoader.chapters.size()]) 
		return
	start_chapter(LevelLoader.chapters[next_index])
	
	
func next_level() -> void: 
	var next_index: int = clamp(current_scene.level_id + 1, 0, current_chapter.levels.size() - 1)
	if next_index > LevelLoader.chapters.size() - 1: 
		printerr("LevelManager: \n Current level ID is %s \n Max Levels: %s \n Cannot next level because there is no more next level. " % [current_room.level_id, current_chapter.levels.size()]) 
		return
	start_level(current_chapter.levels[next_index])
	
	
func next_stage() -> void:
	if (current_scene.stage_id + 1) > current_level.stages.size() - 1: 
		next_level()
	start_stage(current_level.stages[current_scene.stage_id + 1])
	
	
func start_chapter(chapter: LevelChapterResource) -> void: 
	start_level(chapter.levels[0])
	
	
func start_level(level: LevelResource) -> void:
	start_stage(level.stages[0])
	
	
func start_stage(stage: LevelStageResource) -> void:
	change_room(stage.rooms[0].scene)
	
	
# Work on these later when you have implemented the save and load data functions. 
func change_room(new_scene: PackedScene, _save_data: SaveData = null, transition: bool = false, 
		start_animation: String = "", end_animation: String = "", 
		start_animation_speed: int = 1, end_animation_speed: int = 1) -> void:
	change_scene(new_scene, transition, 
		start_animation, end_animation, 
		start_animation_speed, end_animation_speed
	)
	_load_data = _save_data
	
	
func _on_room_is_ready(_room: RoomNode) -> void: 
	if current_scene is RoomNode: 
#		SaveManager.save_data_to_file("", "", true)
		RoomManager.current_room.init()
		if _load_data: 
			SaveManager.load_data(_load_data)
		UIManager.set_gui_active(UIManager.player_screen, true)
		return
	UIManager.set_gui_active(UIManager.player_screen, false)
	
	
func change_scene(new_scene: PackedScene, transition: bool = false, 
		start_animation: String = "", end_animation: String = "", 
		start_animation_speed: int = 1, end_animation_speed: int = 1) -> void:
	var transitions_manager: Control = UIManager.transitions_manager
	if transition:
		await transitions_manager.play_anim(start_animation, start_animation_speed)
	if get_tree().change_scene_to_packed(new_scene) != OK:
		assert(new_scene, "Error: scene is not found ")
		return
	if !(new_scene in scenes_history):
		scenes_history.append(new_scene)
	if transition:
		await transitions_manager.play_anim(end_animation, end_animation_speed)	
	print_debug(get_tree().current_scene)
	
	
func has_visited_scene(scene: Node) -> bool:
	if load(scene.get_file_path()) in scenes_history:
		return true
	return false
	
	
func get_packed_scene_from_current_scene_path(save_file: SaveFile) -> PackedScene: 
	var save_dict: Dictionary = save_file.get_as_dict()
	var current_room_path: PackedStringArray = save_dict["GameData"]["current_scene_path"].split("/")
	var current_chapter_id: int = int(current_room_path[0])
	var current_level_id: int = int(current_room_path[1])
	var current_stage_id: int = int(current_room_path[2])
	var current_room_id: int = int(current_room_path[3])
	var _current_chapter: LevelChapterResource = LevelLoader.chapters[current_chapter_id - 1]
	var _current_scene: PackedScene = _current_chapter.levels[current_level_id].stages[current_stage_id].rooms[current_room_id].scene
	return _current_scene
	
	
func save_data() -> Dictionary: 
	var data: Dictionary = {
		"current_scene_path" : current_scene_path
	}
	return data

