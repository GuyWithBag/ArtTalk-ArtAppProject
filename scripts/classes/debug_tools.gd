extends Node
class_name DebugTools 

class CreateLineTo: 
	var from: Vector2 
	var to: Vector2 
	var width: int 
	var default_color: Color
	var line_name: String = "DebugLine(%s, %s)" % [from, to] 
	
	func _init(_from: Vector2, _to: Vector2, _width: int = 5, _default_color: Color = Color.BLUE) -> void: 
		from = _from
		to = _to
		width = _width
		default_color = _default_color


static func create_line_to(parent: Node2D, config: CreateLineTo, queue_free_time: float = 0) -> Line2D: 
	var line: Line2D = Line2D.new() 
	line.name = config.line_name 
	parent.add_child(line) 
	line.global_position = Vector2(0,0)
	line.add_point(config.from) 
	line.add_point(config.to) 
	line.width = config.width
	line.default_color = config.default_color 
	if queue_free_time != 0: 
		parent.get_tree().create_timer(queue_free_time).timeout.connect(
			func(): 
				line.queue_free()
		)
	return line 
	
	
static func get_relative_target_position(from: Vector2, target_position: Vector2) -> Vector2: 
	return from.direction_to(target_position) * from.distance_to(target_position)
