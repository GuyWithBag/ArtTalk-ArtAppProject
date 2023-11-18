extends Node
class_name OpenAndCloseLogic 

signal unlocked(unlocked_by: Node)
signal locked(locked_by: Node)

signal opened(opened_by: Node)
signal closed(closed_by: Node)

signal attempted_to_open(attempted_by: Node)
signal attempted_to_open_locked(attempted_by: Node)

signal open_door_dialogue_started(opened_by: Node)
signal open_door_dialogue_ended(opened_by: Node)

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

@export var open_type: OpenType = OpenType.NEXT_STAGE
@export var change_room_to: PackedScene 
@export var is_opened: bool = false: 
	set(value): 
		is_opened = value
		if is_opened: 
			unlock_logic.call(null)
			open_logic.call(null)
		
@export var is_locked: bool = false
@export var lock_after_opened: bool = false

@export_group("Required Conditions")
@export var required_condition: RequiredConditionType = RequiredConditionType.NONE
@export var required_key: KeyItem
@export var required_event: String
@export var automatically_open_after_event_called: bool = false
@export var collisions: Array[CollisionShape2D]

@export_subgroup("Open Door Dialogue")
@export var has_open_door_dialogue: bool = false
@export var open_dialogue: DialogueResource
@export var open_dialogue_title: String: 
	get:
		return open_dialogue_title.to_snake_case()

var unlock_logic: Callable 
var open_logic: Callable
var its_locked_logic: Callable
var dialogue_start_logic: Callable

var _initiliazed: bool = false

func _ready() -> void: 
	if automatically_open_after_event_called:
		if WorldEventManager.has_called_event(required_event.to_snake_case()):
			unlock_logic.call(WorldEventManager)
			await attempt_open(WorldEventManager)
			return
		WorldEventManager.event_called.connect(_on_world_event_called)


func init(_unlock_logic: Callable, 
	_its_locked_logic: Callable, _open_logic: Callable, 
	_dialogue_start_logic: Callable) -> void: 
	
	unlock_logic = _unlock_logic
	open_logic = _open_logic
	its_locked_logic = _its_locked_logic
	dialogue_start_logic = _dialogue_start_logic
	_initiliazed = true


func attempt_open(user: Node) -> bool: 
	assert(_initiliazed, "Door: Has not been initilized. Call init() first. ")
	print_debug("OpenAndClosingLogic: %s has been attempted to open" % owner.name)
	attempted_to_open.emit(user)
	if is_locked:
		if _required_condition_has_been_met(user):
			is_locked = false
			unlock_logic.call(user)
			unlocked.emit(user)
		else:
			its_locked_logic.call(user)
			attempted_to_open_locked.emit(user)
			print_debug("OpenAndClosingLogic: %s is locked, Attempted by: %s" % [owner.name, user])
			return false
	if open_dialogue && has_open_door_dialogue: 
		open_door_dialogue_started.emit(user)
		await dialogue_start_logic.call(open_dialogue, open_dialogue_title)
		
		if !WorldEventManager.has_called_event("open_door"): 
			# If the event has not been called, it will not open the door.
			return false
		open_door_dialogue_ended.emit(user)
	open_logic.call(user)
	opened.emit(user)
	return true


func close(user: Node) -> void: 
	is_opened = false
	closed.emit(user)


func _required_condition_has_been_met(user: Node) -> bool:
	match required_condition:
		RequiredConditionType.NONE:
			return true
		RequiredConditionType.KEY_UNLOCK:
			if user.inventory.has_item(required_key):
				return true
			return false
		RequiredConditionType.HAS_EVENT_ACTIVATED:
			if WorldEventManager.has_called_event(required_event):
				return true
			return false
	return false
	
	
func _on_world_event_called(event: WorldEvent, called_by: Node):
	if opened:
		return
	if event.event_id == required_event.to_snake_case():
		unlock_logic.call(called_by)
		await attempt_open(called_by)
		
		
func save_data() -> Dictionary:
	var data: Dictionary = {
		"open_and_close_logic" : {
			"opened" : is_opened, 
			"locked" : is_locked
		}
	}
	return data

