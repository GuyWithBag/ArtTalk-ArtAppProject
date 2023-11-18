extends Resource
class_name TimeResource 

var hour: int
var minute: int
var second: int

func _init(time_dict: Dictionary) -> void: 
	hour = time_dict["hour"]
	minute = time_dict["minute"]
	second = time_dict["second"]
	
	
func _to_string() -> String:
	var time_string: String = "%s : %s : %s" % [hour, minute, second] 
	return time_string


func add(time: TimeResource) -> TimeResource: 
	var sum: TimeResource = TimeResource.new({
		"hour" : time.hour + hour, 
		"minute" : time.minute + minute, 
		"second" : time.second + second
	})
	return sum
	
	
