extends FunctionalItem
class_name ReadableItem

@export var read_data_path: String


func parse_json() -> Dictionary:
	var data: Dictionary = JSON.parse_string(FileAccess.open(read_data_path, FileAccess.READ).get_as_text()).data
	return data
