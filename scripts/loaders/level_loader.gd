extends Node

signal finished_getting_all_chapters(chapters: Array[LevelChapterResource])

var chapters_path: String = "res://levels/chapters/"
var chapters_dir: DirAccess = DirAccess.open(chapters_path)
var chapters_files: PackedStringArray = chapters_dir.get_files()

var chapters: Array[LevelChapterResource] = load_all_chapters()

# Used Stringname (&'a') instead of normal strings because it is faster in performance reasons. 
#func get_room_by_id( chapter_id: int = 0, level_id: int = 0, room_id: int = 0 ) -> Dictionary:
#	return room
	
	
func load_all_chapters() -> Array[LevelChapterResource]: 
	var _chapters: Array[LevelChapterResource] = []
	for file_name in chapters_files: 
		if file_name.ends_with(".tres"): 
			var chapter: LevelChapterResource = load(chapters_path + file_name)
			_chapters.append(chapter)
	finished_getting_all_chapters.emit(chapters)
	return _chapters




