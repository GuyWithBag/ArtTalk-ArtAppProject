extends Node

const path: String = "res://objects/items/"
var data: Array[ItemResource]

func _ready() -> void:
	data.append_array(get_item_resource_files(path))
	pass


func load_all_items() -> void:
	pass


func get_item(item_name: StringName) -> ItemResource:
	for item in data:
		if item.item_name == item_name:
			return item
	return null
	
	
func get_item_resource_files(folder_path) -> Array[ItemResource]:
	return _load_item_resource_files(folder_path)
	
	
func _load_item_resource_files(folder_path) -> Array[ItemResource]:
	# get a list of all the files and directories in the folder
	var dir = DirAccess.open(folder_path)
	if dir == null: 
		printerr("ItemLoader: Directory: ", folder_path, " does not exist. ") 
		return []
	var contents: Array[ItemResource] = []
	for folder in dir.get_directories():
		contents.append_array(get_item_resource_files(folder_path + folder))
		
	# This block will execute if it is a ".tres" file. 
	for file in dir.get_files():
		if file.ends_with(".tres"):
#			print_debug('Found file with ".tres" extension: ', folder_path + "/" + file)
			var item: ItemResource = load(folder_path + "/" + file)
			contents.append(item)
	return contents


