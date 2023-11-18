## Global Information about the game
extends Node

# Logic for save_file_created is in SaveManager.save_data
var save_file_created: DateTime 
var last_saved_data: DateTime: 
	get: 
		return DateTime.new(Time.get_datetime_dict_from_system())
var time_played: TimeResource: 
	get: 
		var total_time: TimeResource = save_file_created.to_time_resource().add(TimeResource.new(Time.get_time_dict_from_system()))
		return total_time
		
# All the dates when data is saved, it currently has no logic, implement later. 
var dates_when_data_is_saved: Array[Dictionary]

func save_data() -> Dictionary: 
	var data: Dictionary = {
		"save_file_created" : save_file_created.to_string(), 
		"last_saved_data" : last_saved_data.to_string(), 
		"time_played" : time_played.to_string(), 
	}
	data.merge(LevelManager.save_data(), true)
	return data
	
	
func load_data(data: Dictionary) -> void: 
	var properties: PackedStringArray = data.keys()
	for property in properties: 
		if property == "current_scene_path": 
			continue
		if property == "state_machine": 
			RoomManager.load_data(data[property])
		self.set(property, data[property]) 
	
	
