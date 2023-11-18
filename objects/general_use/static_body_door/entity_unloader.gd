extends Node
class_name EntityUnloader

signal unloading_started
signal unloading_finished

var unloading_entities: Array[DoorQueuedEntity]

@export var object_of_reference: Node2D
@export var unload_position: Node2D

# The call to unload_entities is called from RoomManager. 
# When the room_is_ready. 
func unload_entities(_unloading_entities: Array[DoorQueuedEntity]) -> void: 
	unloading_entities = _unloading_entities
	unloading_started.emit()
	var door: Door = object_of_reference.get_node("Interactable")
	door.disabled = true
	for door_queued_entity in unloading_entities: 
		var entity_path: String = door_queued_entity.entity_path
		var entity_scene: PackedScene = load(entity_path)
		var entity: Entity = entity_scene.instantiate()
		var unload_time: Timer = entity.door_unload_time
		var already_existing_entity: Entity
		if RoomManager.has_entity(entity): 
			already_existing_entity = RoomManager.get_entity_by_id(entity.id)
			entity.queue_free()
			if !already_existing_entity is Player:
				already_existing_entity.visible = false
			_set_unload_position(already_existing_entity, unload_position)
		await get_tree().create_timer(unload_time.wait_time).timeout
		if is_instance_valid(already_existing_entity): 
			already_existing_entity.visible = true
			return
		RoomManager.entities.add_child(entity)
		_set_unload_position(entity, unload_position)
		unloading_entities.remove_at(unloading_entities.find(entity_path)) 
	await get_tree().create_timer(0.1).timeout
	unloading_finished.emit()
	
	
func queue_entity(entity: Entity) -> void: 
	SaveManager.save_data()
	RoomManager.queue_entity(entity)


func queue_entities(entities: Array[Entity]) -> void: 
	SaveManager.save_data()
	RoomManager.queue_entities(entities)


func _set_unload_position(entity: Entity, _unload_position: Node2D) -> void: 
	entity.position = _unload_position.global_position
	entity.movement_direction = entity.position - object_of_reference.global_position 
	
	
