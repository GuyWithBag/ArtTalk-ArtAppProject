extends Resource
class_name SaveFile 

# These just exist as references since godot does not support static variables
var starting_path: String:
	get: 
		return SaveManager.starting_path
var game_data_folder_path: String:
	get:
		return SaveManager.game_data_folder_path
var saves_folder_path: String:
	get:
		return SaveManager.saves_folder_path

var extension: String = ".json" 

var file_name: String

# Just the file name with the extension
var file_name_ext: String: 
	get: 
		return file_name + extension
		
var file_path: String: 
	get: 
		return saves_folder_path + file_name_ext

var file_exists: bool: 
	get: 
		return FileAccess.file_exists(file_path)
		
var file: FileAccess: 
	get: 
		if make_file: 
			var _file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
			return _file 
		elif file_exists: 
			print_debug("Save file: %s already exists. " % file_name_ext)
			return FileAccess.open(file_path, FileAccess.READ_WRITE)
		printerr("Save file: %s does not exist in Directory. " % file_name_ext)
		return null

var make_file: bool 

func _init(_file_name: String, _make_file: bool = false) -> void:
	file_name = _file_name
	make_file = _make_file


func store_string(data: String) -> void: 
	file.store_string(data)
#	print_debug("Data: " + data)
#	print_debug("File: " + file.get_as_text())


func get_as_text() -> String: 
	return file.get_as_text()
	
	
func get_as_dict() -> Dictionary: 
	return JSON.parse_string(get_as_text())


func get_as_save_data() -> SaveData: 
	var save_data: SaveData = SaveData.new(file_name)
	save_data.data = get_as_dict() 
	return save_data


func close() -> void: 
	file.close()
