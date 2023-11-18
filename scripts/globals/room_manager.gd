extends Node

signal room_is_ready(room: RoomNode)

var current_room: RoomNode
var state_machine: StateMachine 
var world: Node2D
var cameras: Node2D
var objects: Node2D
var tilemap: Node2D
var entities: Node2D
var lights: Node2D
var cutscene_objects: Node2D
var positions: Node2D
var map_borders: Node2D
var created_borders: Node2D

var queued_entities: Array[DoorQueuedEntity] = []
var has_connected_door: bool = false
var connected_door_id: String: 
	get:
		return connected_door_id.to_snake_case()
var connected_door_data: Dictionary

func _ready() -> void:
	room_is_ready.connect(_on_room_is_ready) 


# This is where the data from the previous room will be loaded onto. 
func _on_room_is_ready(_room: RoomNode) -> void: 
	current_room = LevelManager.current_scene
	load_data_from_room_to_this_room()
	state_machine = current_room.state_machine
	world = current_room.world
	cameras = current_room.cameras
	objects = current_room.objects
	lights = current_room.lights
	entities = current_room.entities
	cutscene_objects = current_room.cutscene_objects
	tilemap = current_room.tilemap
	positions = current_room.positions
	map_borders = current_room.map_borders
	created_borders = current_room.created_borders
	
	
# Mostly used by the Door class for unloading entities. 
func has_entity(entity: Entity) -> bool:
	for ent in get_tree().get_nodes_in_group("Entity"): 
		if ent.id == entity.id: 
			return true
	return false
	
	
func get_entity_by_id(entity_id: String) -> Entity: 
	for entity in get_tree().get_nodes_in_group("Entity"): 
		if entity.id == entity_id: 
			return entity
	return null


func save_data() -> Dictionary: 
	var data: Dictionary = {}
	data.merge(current_room.save_data(), true)
	return data
	
	
func load_data(data: Dictionary) -> void: 
	current_room.load_data(data)
	
	
# Purpsoe or function of this is in Door.gd
func load_data_from_room_to_this_room() -> void: 
	if SaveManager.current_saved_data:
		SaveManager.load_data(SaveManager.current_saved_data)
	if has_connected_door && connected_door_id == "": 
		printerr("RoomManager: door_id cannot be a blank value. ")
		return
	for door in get_tree().get_nodes_in_group("Door"): 
		if door.door_id == connected_door_id: 
			print_debug("Found door: %s, Matched with: %s" % [door.door_id, connected_door_id])
			unload_entities_to_door(door)
			load_connected_door_data(door, connected_door_data)
			break
	has_connected_door = false


func queue_entity(entity: Entity) -> void: 
	var door_queued_entity: DoorQueuedEntity = DoorQueuedEntity.new(entity)
	queued_entities.append(door_queued_entity)
	
	
func queue_entities(_entities: Array[Entity]) -> void: 
	for entity in _entities: 
		var door_queued_entity: DoorQueuedEntity = DoorQueuedEntity.new(entity)
		queued_entities.append(door_queued_entity)


func unload_entities_to_door(door: Door) -> void: 
	door.entity_unloader.unload_entities(queued_entities)
	
	
func load_connected_door_data(door: Door, _connected_door_data: Dictionary) -> void: 
	var data: Dictionary = _connected_door_data
	if data.has("lock_after_open"): 
		door.locked = true
	
	
func set_border_disabled(border: StaticBody2D, value: bool) -> void: 
	for collision in border.get_children(): 
		collision.disabled = value
