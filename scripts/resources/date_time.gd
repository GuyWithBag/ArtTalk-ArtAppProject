extends Resource
class_name DateTime

# year, month, day, weekday, hour, minute, second, and dst

var dict: Dictionary

var year: int
var month: int
var day: int
var weekday: int
var hour: int
var minute: int
var second: int
var dst: int


func _init(datetime_dict: Dictionary) -> void: 
	year = datetime_dict["year"]
	month = datetime_dict["month"]
	day = datetime_dict["day"]
	weekday = datetime_dict["weekday"]
	hour = datetime_dict["hour"]
	minute = datetime_dict["minute"]
	second = datetime_dict["second"]
	dst = datetime_dict["dst"]
	dict = datetime_dict
	
	
func _to_string() -> String:
	return Time.get_datetime_string_from_datetime_dict(dict, false)
	
	
func to_time_resource() -> TimeResource: 
	var time_resource: TimeResource = TimeResource.new({
		"hour" : hour, 
		"minute" : minute, 
		"second" : second
	})
	return time_resource
