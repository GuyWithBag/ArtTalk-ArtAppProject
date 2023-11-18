extends Area2D
class_name InteractablesGroup

@export var disable_interactables_area2d: bool = true: 
	set(value): 
		disable_interactables_area2d = value
		for interactable in interactables:
			interactable.get_node("CollisionShape2D").disabled = disable_interactables_area2d
			
@export var disable_interactables_collisions: bool = false:
	set(value): 
		disable_interactables_area2d = value
		for object in objects:
			object.get_node("CollisionShape2D").disabled = disable_interactables_area2d
			
@onready var interactables: Array[Interactable] = []: 
	get: 
		var _interactables: Array[Interactable] = []
		for object in objects:
			_interactables.append(object.get_node("Interactable"))
		return _interactables
		
@onready var objects: Array[Node2D] = []: 
	get: 
		var _objects: Array[Node2D] = []
		for node in get_children(): 
			if node.is_in_group("Interactable"): 
				_objects.append(node)
		return _objects
		
		
