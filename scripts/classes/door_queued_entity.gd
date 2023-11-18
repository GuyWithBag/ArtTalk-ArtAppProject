extends Resource
class_name DoorQueuedEntity


var entity: Entity: 
	set(value): 
		entity = value
		entity_path = entity.scene_file_path
		door_unload_time = entity.door_unload_time

var entity_path: String
#Amount of time it takes for the entity to be unloaded
var door_unload_time: Timer


func _init(_entity: Entity) -> void: 
	entity = _entity
	
