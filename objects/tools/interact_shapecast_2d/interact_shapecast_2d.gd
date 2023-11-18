extends ShapeCast2D
class_name InteractShapeCast2D

signal fired()
signal finished_getting_colliders(interactables_collided: Interactable)
signal interactables_cleared(interactables: Interactable)

@export var fire_mode: bool = true
@export var cast_range: float = 1.5

var interactables_colliding: Array[Interactable]


func fire() -> Array[Interactable]: 
	update_target_direction()
	fired.emit()
	_on_fired()
	var interactables: Array[Interactable] = get_interactables_collding()
	interactables_colliding = interactables
	if !interactables_colliding.is_empty():
		_on_finished_getting_colliders(interactables_colliding)
		finished_getting_colliders.emit(interactables_colliding)
	return interactables_colliding
	
	
func get_interactables_collding() -> Array[Interactable]: 
	var interactables: Array[Interactable] = []
	if !is_colliding(): 
		return interactables
	var collider: Node2D = get_collider(0)
	if collider is Interactable: 
		if collider.interact_type != collider.InteractType.WALK_IN: 
			interactables.append(collider)
	elif collider is InteractablesGroup:
		for interactable in collider.interactables:
			interactables.append(interactable)
	return interactables


func update_target_direction() -> void:
	var movement_direction: Vector2 = owner.movement_direction
	if movement_direction == Vector2.ZERO: 
		movement_direction = owner.previous_movement_direction
	target_position = cast_range * movement_direction * GameManager.UNIT_SIZE
	force_shapecast_update()
	
	
func _on_fired() -> void: 
	pass


func clear_interactables_collided() -> void:
	interactables_cleared.emit(interactables_colliding)
	interactables_colliding.clear()
	_on_interactables_cleared()
	
	
func _on_interactables_cleared() -> void: 
	pass
	
	
func _on_finished_getting_colliders(_interactables_collided: Array[Interactable]) -> void:
	pass

