# RoomNode scenes should be structured like this: MapTemplate > Objects > Cameras > Lighting > Actual Scene
extends Node2D
class_name RoomNode

# These will be used as ID in order to identify which resource should be used in LevelChapterResource
@export var chapter_id: int
@export var level_id: int
@export var stage_id: int
@export var room_id: int

@onready var world: Node2D = get_node("World")
@onready var cameras: Node2D = get_node("Cameras")
@onready var objects: Node2D = get_node("Objects")
@onready var tilemap: Node2D = get_node("Tilemap")
@onready var entities: Node2D = get_node("Entities")
@onready var lights: Node2D = get_node("Lights")
@onready var cutscene_objects: Node2D = get_node("CutsceneObjects")
@onready var state_machine: StateMachine = get_node("StateMachine") 
@onready var positions: Node2D = get_node("Positions") 
@onready var scipts: Node = get_node("Scripts")
@onready var environment: Node2D = get_node("Environment")
@onready var cutscene_player: AnimationPlayer = cutscene_objects.get_node("CutscenePlayer")
@onready var collision_borders: Node2D = world.get_node("CollisionBorders")
@onready var map_borders: Node2D = collision_borders.get_node("MapBorders") 
@onready var created_borders: Node2D = collision_borders.get_node("CreatedBorders") 

@onready var main_game_camera: MainGameCamera = %MainGameCamera
@onready var player: Player = PlayerManager.player


func _ready() -> void:
	var state_machine: StateMachine = GameManager.state_machine
	state_machine.change_state(state_machine.get_state("Playing"))
	LevelManager.current_scene = get_tree().current_scene
	CameraManager.init(main_game_camera)
	CutsceneManager.init(cutscene_player) 
	RoomManager.room_is_ready.emit(self)
	PlayerManager.init()
	WorldEventManager.init()
	UIManager.init()


func init() -> void: 
	UIManager.gui_debugger.debug_room_init()
	state_machine.init(self)


func get_position_node(node_name: String) -> Node2D: 
	return positions.get_node(node_name)


func save_data() -> Dictionary: 
	var data: Dictionary = {
		
	}
	data.merge(state_machine.save_data(), true)
	return data
	
	
func load_data(data: Dictionary) -> void: 
	var properties: Array = data.keys()
	for property in properties: 
		if property == "state_machine": 
			state_machine.load_data(data[property])
			continue
		self.set(property, data[property])
	
	
