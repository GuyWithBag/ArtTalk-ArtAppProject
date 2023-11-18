extends MainGameCamera
class_name CinematicCamera

func get_class_names() -> PackedStringArray: 
	var classes: PackedStringArray = super.get_class_names()
	classes.append("CinematicCamera")
	return classes
