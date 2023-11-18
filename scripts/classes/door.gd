extends Interactable
class_name Door

enum OpenType {
	CHANGE_ROOM, 
	NEXT_STAGE, 
	NEXT_LEVEL,
	NEXT_CHAPTER, 
	PASS_THROUGH,
	STAGE, 
	LEVEL, 
	CHAPTER, 
	SCENE
}

enum DoorType {
	TWO_WAY, 
	ONE_WAY
}

enum RequiredConditionType {
	NONE,
	KEY_UNLOCK,
	HAS_EVENT_ACTIVATED
} 

@export var door_id: String: 
	get:
		return door_id.to_snake_case()
		
@export var connected_door_id: String: 
	get:
		return connected_door_id.to_snake_case()

@export var collisions: Array[CollisionShape2D]

var dialogue_balloon: DialogueBalloonManager = UIManager.dialogue_balloon_manager

@onready var entity_unloader: EntityUnloader = owner.get_node("EntityUnloader")
@onready var open_and_close_logic: OpenAndCloseLogic = owner.get_node("OpenAndCloseLogic")


func _ready() -> void:
	open_and_close_logic.init(_unlock, _door_is_locked, 
		_open, _start_dialogue)
	
	
func _interact(interacted_by: Node, _interactable: Interactable = self) -> void:
	if !open_and_close_logic.is_opened:
		await open_and_close_logic.attempt_open(interacted_by)
	else: 
		open_and_close_logic.close(interacted_by)


func _open(opened_by: Node) -> void:
	print_debug("Door: %s has been opened" % object_name)
	if open_and_close_logic.open_type != OpenType.PASS_THROUGH && opened_by is Entity: 
		RoomManager.has_connected_door = true
		RoomManager.connected_door_id = connected_door_id
		entity_unloader.queue_entity(opened_by)
	var change_room_to: PackedScene = open_and_close_logic.change_room_to
	match open_and_close_logic.open_type:
		OpenType.CHANGE_ROOM:
			if !change_room_to:
				printerr("Door: Missing scene: ", change_room_to)
				return
			LevelManager.change_room(change_room_to)
		OpenType.NEXT_STAGE:
			LevelManager.next_stage()
		OpenType.NEXT_LEVEL:
			LevelManager.next_level()
		OpenType.NEXT_CHAPTER:
			LevelManager.next_chapter()
		OpenType.SCENE:
			LevelManager.change_scene(change_room_to)
			_open_door_sprite()
		OpenType.PASS_THROUGH:
			_disable_collisions(true)
			_open_door_sprite()
	
	
func _open_door_sprite() -> void:
	pass


func _close(_closed_by: Node) -> void:
	_disable_collisions(false)


func _door_is_locked(_attempted_by: Node) -> void:
	pass
	
	
func _unlock() -> void: 
	pass
	
	
func _disable_collisions(value: bool) -> void:
	for _collision in collisions: 
		_collision.call_deferred("disabled", value)
	
	
func _save_data() -> Dictionary:
	var data: Dictionary = {}
	data.merge(open_and_close_logic.save_data(), true)
	return data
	
	
