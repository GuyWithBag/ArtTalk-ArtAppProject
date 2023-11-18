extends Resource
class_name SaveData

var groups_to_save: Array[String] = [
	"Entity", 
	"Interactable"
]

var save_name: StringName
var data: Dictionary = {}


func _init(_save_name: String = "") -> void:
	if _save_name == "": 
		_save_name = SaveManager.generate_indexed_name_from_save_files(SaveManager.save_file_name).to_pascal_case()
	self.save_name = _save_name


func save_game(scene_tree: SceneTree) -> void: 
	if !LevelManager.current_scene is RoomNode: 
		printerr("SaveData: Cannot save_game because the current_scene is not a RoomNode. ")
	# Will only set the save_file_created if the file does not already exist. 
	if save_data_is_new(save_name): 
		GameData.save_file_created = DateTime.new(Time.get_datetime_dict_from_system())
	data["SaveName"] = save_name
	data["GameData"] = {} 
	data["GameData"] = GameData.save_data()
	data["PlayerData"] = PlayerManager.save_data()
	data["LevelChapters"] = {}
	data["LevelChapters"][str(RoomManager.current_room.chapter_id)] = {}
	var chapter = data["LevelChapters"][str(RoomManager.current_room.chapter_id)]
	chapter[str(RoomManager.current_room.level_id)] = {}
	var level = chapter[str(RoomManager.current_room.level_id)]
	level[str(RoomManager.current_room.stage_id)] = {}
	var stage = level[str(RoomManager.current_room.stage_id)]
	stage[str(RoomManager.current_room.room_id)] = {}
	var current_room_data = stage[str(RoomManager.current_room.room_id)]
	for group in groups_to_save:
		var nodes_in_group = scene_tree.get_nodes_in_group(group)
		current_room_data[group] = {}
		for node in nodes_in_group:
			if node.is_in_group("Player"): 
				continue
			var node_data: Dictionary = node.save_data()
			if group == "Interactable": 
				current_room_data[group][node.get_path()] = node_data
				continue
			elif group == "Entity": 
				current_room_data[group][node.id] = node_data
				continue
			current_room_data[group][node.get_path()] = node_data
	current_room_data["RoomData"] = RoomManager.save_data()
	
	
func to_json() -> JSON: 
	var json: JSON = JSON.new()
	var error = json.parse(JSON.stringify(data))
	if error == OK:
		return json
	return null

# Proud of this code lol. Shame it will go to waste. 
#func _convert_object_data_to_dictionary(object_data: Dictionary) -> Dictionary:
#	var new_data: Dictionary = object_data.duplicate()
#	for key in new_data.keys():
##		print("\nnew_data: ", new_data, "\n || key: ", key)
#		var key_data = new_data[key]
##		print(" || data: ", key_data)
#		if key_data is Object: 
#			if key_data.has_method("save_data"):
#				new_data[key] = key_data.save_data()
#		elif key_data is Dictionary:
#			if key_data.is_empty():
#				continue
#			new_data[key] = _convert_object_data_to_dictionary(key_data)
#	return new_data


func save_data_is_new(_save_name) -> bool: 
	if SaveManager.does_save_file_name_already_exist(_save_name): 
		return false
	return true
	
	

