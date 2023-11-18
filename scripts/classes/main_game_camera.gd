extends Camera2D
class_name MainGameCamera

signal started_transitioning(from_camera: Camera2D, to_camera: Camera2D)
signal finished_transitioning(from_camera: Camera2D, to_camera: Camera2D)

@export var current_camera_focused: GameCamera
# This will allow for instant transitions while transitioning only

@export_group("") 


var transitioning: bool = false
var _properties_to_transition: PackedStringArray = [
	"zoom", 
	"limit_left", 
	"limit_top", 
	"limit_right", 
	"limit_bottom"
]

var _smoothing_properties: PackedStringArray = [
	"position_smoothing_enabled", 
	"rotation-smoothing_enabled", 
	"limit_smoothed", 
	"drag_horizontal_enabled", 
	"drag_vertical_enabled"
]

# Follow node is processed in CameraManager. 
func _ready() -> void: 
	await RoomManager.room_is_ready
	CameraManager.set_main_game_camera(self)
	if current_camera_focused: 
		CameraManager.transition_to_new_camera(current_camera_focused, 0)


# WHY DOES IT SMOOTHLY TRANSITION EVEN THO I HAVE TURNED IT INTO FALSE THEN TRUE AFTERWARDS
func transition_to_new_camera(new_camera: Camera2D, duration: float = 0) -> void: 
	var previous_camera: Camera2D = current_camera_focused
	var finished_transitioning_logic: Callable = func(): 
		finished_transitioning.emit(previous_camera, new_camera)
		transitioning = false
		if new_camera is GameCamera: 
			current_camera_focused = new_camera
		for property in _smoothing_properties: 
			self.set(property, new_camera.get(property))
		position_smoothing_speed = new_camera.position_smoothing_speed
		rotation_smoothing_speed = new_camera.rotation_smoothing_speed
		drag_horizontal_offset = new_camera.drag_horizontal_offset
		drag_vertical_offset = new_camera.drag_vertical_offset
		
	started_transitioning.emit(previous_camera, new_camera)
	transitioning = true
	if new_camera is GameCamera: 
		CameraManager.follow_node(new_camera.follow_node) 
	if duration == 0: 
		for property in _smoothing_properties: 
			self.set(property, false)
#		global_position = CameraManager.currently_following_node.global_position
		for property in _properties_to_transition: 
			self.set(property, new_camera.get(property))
#		await get_tree().physics_frame
		if new_camera is GameCamera: 
			if new_camera.follow_node == null: 
				global_position = new_camera.global_position
		finished_transitioning_logic.call()
	else: 
		var transition: Tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		transition.finished.connect(
			func(): 
				finished_transitioning_logic.call()
		, CONNECT_ONE_SHOT
		)
		for property in _properties_to_transition: 
			transition.tween_property(self, property, new_camera.get(property), duration)
		transition.play()
	await finished_transitioning


func get_class_names() -> PackedStringArray: 
	return ["MainGameCamera"]
