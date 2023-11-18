extends Node

signal transitioned_to_cinematic_camera(camera: Camera2D)
signal transitioned_to_new_camera(camera: Camera2D)
signal found_cameras_in_scene(cameras: Array[Camera2D])

signal started_following_node(camera: Camera2D, node_following: Node2D)
signal stopped_following_node(camera: Camera2D, node_stopped_following: Node2D)

# This script is used for controlling the camera, to use: 
# - First set the main cam 
# - then use transition to move to other game cameras 
#
# Transitioning to another camera manually should only use methods here, 
# using transition_to_new_camera() manually through GameCamera should be forbidden. 

var cameras: Array[Camera2D]
var main_game_camera: MainGameCamera
var current_cinematic_camera: CinematicCamera
var current_camera_focused: GameCamera
var currently_following_node: Node2D

func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS


func init(_main_game_camera: MainGameCamera) -> void:
	cameras = find_cameras_in_scene()
	set_main_game_camera(_main_game_camera)
	
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(currently_following_node): 
		if !is_instance_valid(main_game_camera): 
			return
		main_game_camera.global_position = currently_following_node.global_position
	
	
func get_camera(camera_name: String) -> Camera2D:
	for cam in cameras:
		if cam.name == camera_name.to_pascal_case():
			return cam
	printerr("Camera: %s is not found. It could be not added in the 'Camera' group. " % camera_name)
	return null
	
	
func find_cameras_in_scene() -> Array[Camera2D]:
	var _cameras: Array[Camera2D] = []
	for cam in get_tree().get_nodes_in_group("Camera"):
		_cameras.append(cam)
	if !(_cameras.is_empty()): 
		found_cameras_in_scene.emit(_cameras)
	return _cameras


func set_main_game_camera(new_camera: MainGameCamera) -> void: 
	main_game_camera = new_camera
	main_game_camera.make_current()
	print_debug("\nCurrent Main Game Camera: %s \n" % new_camera.name)


func transition_to_cinematic_camera(new_camera: CinematicCamera, duration: float = 0) -> void: 
	new_camera.finished_transitioning.connect(
		func(_from_camera: Camera2D, _to_camera: Camera2D): 
			current_cinematic_camera = new_camera
			current_cinematic_camera.make_current()
			print_debug("\nTransitioned to New MainGameCamera: %s, Following Node: %s \n" % [current_camera_focused, current_camera_focused.follow_node])
			transitioned_to_cinematic_camera.emit(new_camera)
	, CONNECT_ONE_SHOT 
	)
	await new_camera.transition_to_new_camera(new_camera, duration)


func back_to_main_game_camera() -> void: 
	main_game_camera.make_current()
	


func transition_to_new_camera(new_camera: GameCamera, duration: float = 0) -> void: 
	if new_camera == null: 
		printerr("Cannot transition to Camera: %s, because it is null. " % new_camera)
		return
	if main_game_camera.transitioning == true:  
		return
	main_game_camera.finished_transitioning.connect(
		func(from_camera: Camera2D, to_camera: Camera2D): 
			current_camera_focused = new_camera
			new_camera.init()
			print_debug("\nTransitioned to Camera: %s, Following Node: %s \n" % [current_camera_focused, current_camera_focused.follow_node])
			transitioned_to_new_camera.emit(new_camera)
	, CONNECT_ONE_SHOT 
	)
	# So that you can use await with this function, instead of await transitioned_to_new_camera
	await main_game_camera.transition_to_new_camera(new_camera, duration)


func follow_node(node_to_follow: Node2D) -> void: 
	currently_following_node = node_to_follow 
	if !is_instance_valid(node_to_follow): 
#		printerr("CameraManager: Cannot follow node if node is null or doesn't exist. ") 
		return
	started_following_node.emit(current_camera_focused, currently_following_node)


func stop_following_node() -> void: 
	var previous_node_following: Node2D = currently_following_node
	currently_following_node = null
	stopped_following_node.emit(current_camera_focused, previous_node_following)


func is_currently_following_node() -> bool: 
	if currently_following_node: 
		return true
	return false
