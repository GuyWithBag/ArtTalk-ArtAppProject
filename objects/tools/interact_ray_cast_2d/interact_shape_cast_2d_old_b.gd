extends ShapeCast2D
class_name InteractRayCast2D

signal interacted(object: Interactable)

@export var maximum_range: float = 2:
	set(value):
		maximum_range = value * GameManager.UNIT_SIZE
@export var minimum_range: float = 1:
	set(value):
		minimum_range = value * GameManager.UNIT_SIZE
@export var debug: bool = false
@export var fire_mode: bool = true

var objects_colliding: Array[Area2D]

@onready var parent: Node2D = get_parent()
@onready var area2d: Area2D = get_node("Area2D")
@onready var collision_shape: CollisionShape2D = area2d.get_node("CollisionShape2D")
@onready var label = get_node("%Colliders")

func _ready() -> void:
	maximum_range = maximum_range
	minimum_range = minimum_range
	collision_shape.shape.radius = maximum_range


func _process(_delta) -> void: 
	if fire_mode:
		if parent.movement_direction != Vector2.ZERO:
			target_position = parent.movement_direction * minimum_range
		return
	# Set's the raycast and area2d raidus to the raycast range wihout turning into 0
	if parent.movement_direction != Vector2.ZERO:
		target_position = parent.movement_direction * maximum_range
		collision_shape.shape.radius = maximum_range
#
#	while is_colliding():
#		var collider: Interactable
#		collider = get_collider() #get the next object that is colliding.		
#		if area2d.get_overlapping_areas().has(collider):
#			add_multiple_colliders(collider)
#			_on_raycast_collider_added(collider)
			
		# If it is no longer colliding with the raycast and the area2d, it will now remove it from the objects colliding array
#	print("Objects Colliding: ", objects_colliding)
	for collider in objects_colliding:
		if owner.movement_direction != owner.previous_movement_direction:
			if !(collider in area2d.get_overlapping_areas()):
				collider_stopped_colliding(collider)

# Use interact ray for collision
# Check if interact ray collider is also in collision with area 2d
# If the collider is not in area 2d, remove that collider

func fire() -> Array[Area2D]:
	while is_colliding():
		var collider: Area2D = get_collider(0) #get the next object that is colliding.
		add_multiple_colliders(collider)
#	clear_colliders()
	_on_finished_getting_colliders()
	return objects_colliding


func add_multiple_colliders(collider: Area2D) -> void:
	if debug:
		print_debug(collider)
	objects_colliding.append(collider)
	add_exception(collider)
	force_shapecast_update() 
	if collider is InteractablesGroup:
		for interactable in collider.interactables:
			if !objects_colliding.has(interactable):
				objects_colliding.append(interactable)
			add_exception(interactable)
			force_shapecast_update()
			if debug:
				print_debug("inside group: " + String(interactable.object_name))
	
	
func _on_finished_getting_colliders() -> void:
	pass


func collider_stopped_colliding(collider: Interactable) -> void:
	objects_colliding.remove_at(objects_colliding.find(collider))
	remove_exception(collider)
	_on_collider_stopped_colliding(collider)
	
	
func _on_collider_stopped_colliding(_collider: Interactable) -> void:
	pass


