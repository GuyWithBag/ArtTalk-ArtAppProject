extends Node

# WorldEventManager is for calling event scripts that only activate once
# StateMachine is for scipts that describe the current state of the game, they can also run more than once and it is the main script of the scene like a _ready() function

signal event_called(event: WorldEvent, called_by: Node)

var events_in_scene: Array[WorldEvent]
var previous_called_events: PackedStringArray
var world_event_handler: Node 
var generic_events: Node
var specific_events: Node

func init() -> void:
	var current_scene: Node = LevelManager.current_scene
	world_event_handler = current_scene.get_node("WorldEventHandler")
	generic_events = world_event_handler.get_node("GenericEvents")
	specific_events = world_event_handler.get_node("SpecificEvents")


# It is called call_event because you need to create a world event node in the world event handler
func call_event(event_name: String, called_by: Node) -> void:
	var world_event: WorldEvent = get_world_event_node(event_name)
	world_event.call_event(called_by)
	print_debug("Event Called: ", world_event.event_id, " by: ", called_by)
	previous_called_events.append(world_event.event_id)
	event_called.emit(world_event, called_by)


func has_called_event(event_name: String) -> bool:
	for event in previous_called_events:
		if event == event_name.to_snake_case():
			return true
	return false
	
	
func get_world_event_node(event_name: String) -> WorldEvent: 
	event_name = event_name.to_pascal_case()
	if generic_events.has_node(event_name): 
		return generic_events.get_node(event_name)
		
	if specific_events.has_node(event_name): 
		return specific_events.get_node(event_name)
	printerr("Error: WorldEvent: %s, cannot be found in WorldEventHandler. " % event_name)
	return null


func save_data() -> Dictionary: 
	var data: Dictionary = {}
	return data
