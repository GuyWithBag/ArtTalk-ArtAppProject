@tool
extends Camera2D 
class_name GameCamera

# Might change it so that it uses area2ds instead to detect which camera to move to

# Area 2D is for detecting if the player has went to that area so that the camera can transition to that point. 
@export var should_have_area_2d: bool = true
@export var transition_duration: float = 0
@export var one_shot: bool = false
@export var disabled: bool = false

@export var follow_node_path: NodePath

@export_group("Camera Tools")
@export_subgroup("Camera Side Positions")
@export var left_side_position: int
@export var top_side_position: int
@export var right_side_position: int
@export var bottom_side_position: int

@export_subgroup("Match values to other values")
@export var match_limits_with_side_positions: bool = false: 
	set(value): 
		match_limits_with_side_positions = value 
		if Engine.is_editor_hint(): 
			if value == true: 
				set_camera_limits(CameraLimits.new(
					left_side_position, 
					top_side_position, 
					right_side_position, 
					bottom_side_position
				))
				match_limits_with_side_positions = false
# This doesn't work properly yet lol
@export var match_area_2d_with_limits: bool = false: 
	set(_value): 
		if !Engine.is_editor_hint(): 
			return
		area_2d = get_node("Area2D")
		if !area_2d.has_node("CollisionShape2D"): 
			if should_have_area_2d:
				printerr("CollisionShape2D From Camera: %s is not found. " % self)
			return
		var collision: CollisionShape2D = area_2d.get_node("CollisionShape2D")
		area_2d.position = get_rectangle_centroid(limit_left, limit_right, limit_top, limit_bottom)
		collision.shape.size = abs(Vector2(limit_left - limit_right, limit_top - limit_bottom))
		match_area_2d_with_limits = false
@export var match_limits_with_area_2d: bool = false: 
	set(_value): 
		if !Engine.is_editor_hint(): 
			return
		area_2d = get_node("Area2D")
		if !area_2d.has_node("CollisionShape2D"): 
			if should_have_area_2d:
				printerr("CollisionShape2D From Camera: %s is not found. " % self)
			return
		var collision: CollisionShape2D = area_2d.get_node("CollisionShape2D")
		var col_size: Vector2 = collision.shape.size
		set_camera_limits(CameraLimits.new(
			((col_size.x * -1) / 2) + collision.global_position.x,
			((col_size.y * -1) / 2) + collision.global_position.y,
			(col_size.x / 2) + collision.global_position.x,
			(col_size.y / 2) + collision.global_position.y
		))
		match_limits_with_area_2d = false
@export var match_object_detection_with_area_2d: bool = false: 
	set(_value):
		if !Engine.is_editor_hint(): 
			return
		area_2d = get_node("Area2D")
		if !area_2d.has_node("CollisionShape2D"): 
			if should_have_area_2d:
				printerr("CollisionShape2D From Camera: %s is not found. " % self)
			return
		object_detection = get_node("ObjectDetection")
		var area_2d_collision: CollisionShape2D = area_2d.get_node("CollisionShape2D")
		var collision: CollisionShape2D = object_detection.get_node("CollisionShape2D")
		collision.shape.size = area_2d_collision.shape.size
		collision.position = area_2d_collision.position
		object_detection.position = area_2d.position
		
var viewport_size_path: String = "display/window/size/viewport_" 
var viewport_width: String = viewport_size_path + "width"
var viewport_height : String= viewport_size_path + "height"
var viewport_rect_size: Vector2 = Vector2(ProjectSettings.get_setting_with_override(viewport_width), ProjectSettings.get_setting_with_override(viewport_height))
var follow_node: Node2D

@onready var area_2d: Area2D = get_node("Area2D")
@onready var object_detection: Area2D = get_node("ObjectDetection")


func _ready() -> void: 
	if !Engine.is_editor_hint(): 
		if !follow_node_path.is_empty(): 
			follow_node = get_node(follow_node_path)
		await RoomManager.room_is_ready


func init() -> void: 
	if follow_node == null: 
		return
	if !follow_node.visible_on_screen_notifier.screen_exited.is_connected(_on_followed_node_screen_exited): 
		follow_node.visible_on_screen_notifier.screen_exited.connect(_on_followed_node_screen_exited.bind(follow_node), CONNECT_ONE_SHOT) 


func _process(_delta: float) -> void: 
	if Engine.is_editor_hint(): 
		var current_position: Vector2 = position
		viewport_size_path = "display/window/size/viewport_"
		viewport_width = viewport_size_path + "width"
		viewport_height = viewport_size_path + "height"
		viewport_rect_size = Vector2(ProjectSettings.get_setting_with_override(viewport_width), ProjectSettings.get_setting_with_override(viewport_height))
		
		left_side_position = (current_position.x - ((viewport_rect_size.x / zoom.x) / 2))
		right_side_position = (current_position.x + ((viewport_rect_size.x / zoom.x) / 2))
		top_side_position = (current_position.y - ((viewport_rect_size.y / zoom.y) / 2))
		bottom_side_position = (current_position.y + ((viewport_rect_size.y / zoom.y) / 2))
		
		# So that the area 2D cannot be smaller than the rect size
#		if should_have_area_2d:
#			var collision: CollisionShape2D = area_2d.get_node("CollisionShape2D")
#			var shape: RectangleShape2D = collision.shape
#			if shape.size.length() / zoom.length() <= viewport_rect_size.length() / zoom.length(): 
#				shape.size = viewport_rect_size * zoom


func get_rectangle_centroid(x1: float, x2: float, y1: float, y2: float) -> Vector2:
	var centroid_x = (x1 + x2) / 2.0
	var centroid_y = (y1 + y2) / 2.0
	var centroid = Vector2(centroid_x, centroid_y) - position
	return centroid
	
	
func transition_to_new_camera(next_camera: GameCamera, duration: float) -> void: 
	if disabled: 
		printerr("%s is a disabled camera. You cannot transition to this one. " % self.name)
		return
	CameraManager.transition_to_new_camera(next_camera, duration)
	if one_shot: 
		disabled = true 


func transition_to_this_camera(duration: float) -> void: 
	transition_to_new_camera(self, duration)


func set_camera_limits(limits: CameraLimits) -> void: 
	limit_left = limits.left
	limit_top = limits.top
	limit_right = limits.right
	limit_bottom = limits.bottom


# This logic is for when the player has already exited the camera, but there are no camera area available outside the screen
# So when it has detected a new camera area, it will transition to that camera. 
func _on_object_detection_body_entered(body: Node2D) -> void:
#	return
	var on_screen_notifier: VisibleOnScreenNotifier2D = body.get_node("VisibleOnScreenNotifier2D") 
	if !on_screen_notifier.is_on_screen(): 
		transition_to_this_camera(transition_duration) 


# When the followed node has exited the screen
func _on_followed_node_screen_exited(node: Node2D) -> void: 
	if CameraManager.current_camera_focused == self: 
		return
	printerr(self)
	if object_detection.overlaps_body(node): 
		transition_to_this_camera(transition_duration)


class CameraLimits extends Resource: 
	var left: int
	var top: int
	var right: int
	var bottom: int

	func _init(_left: int, _top: int, _right: int, _bottom: int) -> void: 
		left = _left
		top = _top
		right = _right
		bottom = _bottom


func get_class_names() -> PackedStringArray: 
	return ["GameCamera"]
