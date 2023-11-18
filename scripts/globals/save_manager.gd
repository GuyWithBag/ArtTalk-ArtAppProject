extends Node

signal saved_data(data: SaveData)
signal loaded_data(data: SaveData)

signal saved_data_to_file(data: SaveData, save_file: SaveFile)
signal loaded_data_from_file(data: SaveData, save_file: SaveFile)
signal save_file_removed( save_file: SaveFile)

signal save_files_edited(new_save_files: Array[SaveFile])

# SaveData class is for loading in between levels and writing to file. 
# To load data from a save file, load data directly from the file, it is not turned into a SaveData object. 

var current_saved_data: SaveData 
var current_saved_data_file: String 

var starting_path: String = "res://"
var game_data_folder_path: String = starting_path + "HorrorGame/"
var saves_folder_path: String = game_data_folder_path + "saves/" 
var save_file_name: String = "save_file_%s"
var autosave_file_name: String = save_file_name % "%s_autosave"

# Chapter, Level, Stage, Room

# The Data Structure still needs to be worked on. 

# Data Structure: 
# WorldData : {
# 	dates_saved : [(push_front latest data)], 
# 	amount_of_time_played : 00:00:00, 
# 	first_time_launched : true
# }
# PlayerData : {
# 	health : 10, 
#	name : "no"
# }
# LevelChapter : {
# 	[chapter_id] : {
# 		[level_id] : {
# 			[stage_id] : {
# 				[room_id] : {
# 					scene : load(""), 
# 					room_data : {}
#				}
# 			}
# 		}
# 	}
# }
#
#
#
func _ready() -> void:
	# Creates a directory/folder in the specified location statically. 
	DirAccess.make_dir_absolute(game_data_folder_path)
	DirAccess.make_dir_absolute(saves_folder_path)


func save_game_and_save_data_to_file(save_data_name: StringName = "", new_save_file_name: String = "", autosave: bool = false) -> SaveFile: 
	save_data(save_data_name)
	return save_data_to_file(save_data_name, new_save_file_name, autosave)


func save_data_to_file(save_data_name: StringName = "", new_save_file_name: String = "", autosave: bool = false) -> SaveFile:
	var _save_data: SaveData = save_data(save_data_name)
	var make_file: bool = true
	if new_save_file_name == "": 
		make_file = true
		if autosave: 
			new_save_file_name = generate_indexed_name_from_save_files(autosave_file_name)
		else: 
			new_save_file_name = generate_indexed_name_from_save_files(save_file_name)
	else: 
		make_file = false
	# Automatically creates a SaveFile in the save_folder_path once created. 
	# But also automatically opens te file. Close the file afterwards with save_file.close()
	var save_file: SaveFile = SaveFile.new(new_save_file_name, make_file)
	var json: JSON = _save_data.to_json()
	save_file.store_string(JSON.stringify(json.data))
	saved_data_to_file.emit(_save_data, save_file.file_name)
	save_files_edited.emit(get_save_files())
	return save_file
	
	
func generate_indexed_name_from_save_files(name_to_be_indexed: String) -> String:
	var new_save_file_name: String
	var save_files: Array[SaveFile] = get_save_files()
	# If no name is provided, it will automatically create a name for it. 
	if save_files_is_empty(): 
		new_save_file_name = name_to_be_indexed % 1
	# If the save files aren't empty, then it will create save files based on the amount of save files there is. 
	for i in save_files.size(): 
		var file_number: int = i + 2
		if !does_save_file_name_already_exist(save_file_name % (file_number)): 
			new_save_file_name = name_to_be_indexed % (file_number)
	return new_save_file_name


func remove_save_file(save_file: SaveData) -> void: 
	save_file_removed.emit(save_file)
	save_files_edited.emit(get_save_files())
	
	
func load_data_from_file(save_file: SaveFile) -> void:
	# Perform read from file from name here
	var _load_data: SaveData = save_file.get_as_save_data() 
	load_data(_load_data)
	loaded_data_from_file.emit(_load_data, save_file)
	pass


func does_save_file_name_already_exist(file_name: String) -> bool: 
	var saves_folder_dir: DirAccess = DirAccess.open(saves_folder_path)
	if saves_folder_dir.file_exists(file_name): 
		return true
	return false


# Functionally the same code as does_save_file_exist, added for readability and posible future use. 
func save_file_will_be_overwritten(save_file: SaveFile) -> bool: 
	if does_save_file_exist(save_file): 
		return true
	return false


func does_save_file_exist(save_file: SaveFile) -> bool:
	var saves_folder_dir: DirAccess = DirAccess.open(save_file.saves_folder_path)
	if saves_folder_dir.file_exists(save_file.file_name): 
		return true
	return false


func save_data_to_dictionary(_save_data: SaveData) -> Dictionary:
	var data: Dictionary = {}
	return data


# Stores it into current_save_data, as well as returns the data itself. 
func save_data(save_name: String = "SaveFile") -> SaveData:
	var _save_data: SaveData = SaveData.new(save_name)
	_save_data.save_game(get_tree())
	
	current_saved_data = _save_data
	saved_data.emit(current_saved_data)
	return _save_data
	
	
func load_data(_save_data: SaveData) -> void:
	# Perform loading SaveData to the nodes here. 
	# Unfinished code. 
	var data: Dictionary = _save_data.data
	var chapter_id: String = str(RoomManager.current_room.chapter_id)
	var level_id: String = str(RoomManager.current_room.level_id)
	var stage_id: String = str(RoomManager.current_room.stage_id)
	var room_id: String = str(RoomManager.current_room.room_id)
	
	if !data["LevelChapters"].has(chapter_id): 
		return
	var chapter = data["LevelChapters"][chapter_id]
	if !chapter.has(level_id): 
		return
	var level = chapter[level_id]
	if !level.has(stage_id): 
		return
	var stage = level[stage_id]
	if !stage.has(room_id): 
		return
	var current_scene_data = stage[room_id]
	for group in current_scene_data.keys(): 
		match group: 
			"Interactable": 
				var interactables: Dictionary = current_scene_data[group]
				for node_path in interactables.keys(): 
					var node: Node2D = get_node(node_path)
					var node_data: Dictionary = interactables[node_path]
					node.load_data(node_data)
			"Entity": 
				var entities: Dictionary = current_scene_data[group]
				for id in entities.keys(): 
					var entity: Entity = RoomManager.get_entity_by_id(id) 
					var entity_data =  entities[id]
					entity.load_data(entity_data)
			"RoomData": 
				var room_data: Dictionary = current_scene_data[group]
				RoomManager.load_data(room_data)
	for key in data.keys(): 
		match key: 
			"PlayerData": 
				var player: Player = get_tree().get_first_node_in_group("Player")
				var player_data = data[key]
				player.load_data(player_data)
			"GameData": 
				var game_data: Dictionary = data[key]
				GameData.load_data(game_data)
				
	loaded_data.emit(_save_data)
	
	
func save_files_is_empty() -> bool:
	if get_save_files().is_empty():
		return true
	return false


func get_save_files() -> Array[SaveFile]: 
	var save_files: Array[SaveFile] = []
	for file in DirAccess.get_files_at(saves_folder_path): 
		var file_name: String = get_file_name(file, false)
		if !file_name.begins_with(save_file_name % ""):
			continue
		var save_file: SaveFile = get_save_file(file_name)
		save_files.append(save_file)
	return save_files 


# Gets the name of the file, or the last name in the directory. 
func get_file_name(file_path: String, with_extension: bool = true) -> String: 
	var last_dir: int = file_path.count("/")
	var split: PackedStringArray = file_path.split("/")
	var file_name: String = split[last_dir]
	if !with_extension: 
		file_name = file_name.split(".")[0]
	return file_name 


func get_save_file(file_name: String) -> SaveFile: 
	return SaveFile.new(file_name, false)


# WIP
func get_most_recent_save_file() -> SaveFile: 
	var maxxed_file: String
	for save_file in get_save_files(): 
		var file_path: String = save_file.file_path
		if FileAccess.get_modified_time(file_path) > FileAccess.get_modified_time(maxxed_file): 
			maxxed_file = file_path
	var most_recent_save_file: SaveFile
	return most_recent_save_file
