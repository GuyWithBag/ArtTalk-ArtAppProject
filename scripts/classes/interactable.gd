@tool
extends Area2D
class_name Interactable

# CollisionPolygon not working???

# If it is not functioning, the InteractableArea2D maybe not be connected here. 
enum InteractType {
	TOUCH,
	WALK_IN
}

signal interacted(interacted_by: Node, interactable: Interactable)
signal walk_in_interacted(interacted_by: Node, interactable: Interactable)
signal touch_interacted(interacted_by: Node, interactable: Interactable)

signal interaction_started(interacted_by: Node, interactable: Interactable)
signal interaction_ended(interacted_by: Node, interactable: Interactable)

@export var interact_type: InteractType = InteractType.TOUCH
@export var object_name: String = "MISSING NAME"
@export var call_world_event: String
@export var disabled: bool = false: 
	set(value): 
		disabled = value
		set_deferred("monitorable", value)
		set_deferred("monitoring", value)
		
## This is the amount of times you can interact with this object
@export_group("Interact Limit")
@export var interact_limit: int = 0
@export var queue_free_after_interact_limit_hit: bool = false


@export_group("Interact Dialogue")
@export var dialogue_variety_amount: int = 1: 
	set(value): 
		dialogue_variety_amount = clamp(value, 1, 99)
		
@export var starting_interact_dialogue: DialogueResource
@export var starting_interact_dialogue_title: String: 
	get: 
		return starting_interact_dialogue_title.to_snake_case()
		
@export var ending_interact_dialogue: DialogueResource
@export var ending_interact_dialogue_title: String: 
	get: 
		return starting_interact_dialogue_title.to_snake_case()

var interact_count: int = 0
var dialogue_variation: int = 0: 
	get: 
		return interact_count % dialogue_variety_amount

@onready var interactable_node: Node2D = owner
@onready var dialogue_balloon_manager: DialogueBalloonManager = UIManager.dialogue_balloon_manager


func interact(interacted_by: Node, _interactable: Interactable = self) -> void:
	assert(interact_type == InteractType.TOUCH, "Interact type is WALK_IN")
	if interact_type != InteractType.TOUCH: 
		return
	start_interact_process(InteractType.TOUCH, interacted_by)


# First, you must connect the Area2D signals to here
func _on_area_entered(area: Area2D) -> void:
	_on_walk_in_interacted(area)
	
	
func _on_walk_in_interacted(interacted_by: Node) -> void:
	assert(interact_type == InteractType.WALK_IN, "Interact type is TOUCH") 
	if interact_type != InteractType.WALK_IN: 
		return
	start_interact_process(InteractType.WALK_IN, interacted_by)
	
	
func start_interact_process(_interact_type: InteractType, interacted_by: Node) -> void: 
	match _interact_type: 
		InteractType.TOUCH: 
			_interact_process(_touch_interact, touch_interacted, interacted_by)
		InteractType.WALK_IN: 
			_interact_process(_walk_in_interact, walk_in_interacted, interacted_by)
			
			
func _interact_process(interact_logic: Callable, interact_signal: Signal, interacted_by: Node) -> void: 
	if Engine.is_editor_hint(): 
		return
	var interactable: Interactable = self
	await _interaction_starting(interacted_by, interactable)
	await _interact(interacted_by, interactable)
	interact_logic.call(interacted_by, interactable)
	interacted.emit(interacted_by, interactable)
	interact_signal.emit(interacted_by, interactable)
	await _interaction_ending(interacted_by, interactable)
	_interact_end(interacted_by, interactable)
	interaction_ended.emit(interacted_by, interactable)
	interact_count += 1
	if interact_limit > 0 && interact_count >= interact_limit: 
		disabled = true
		if queue_free_after_interact_limit_hit: 
			queue_free() 
		return
	
	
func _interaction_starting(interacted_by: Node, interactable: Interactable = self) -> void: 
	interaction_started.emit(interacted_by, interactable)
	if starting_interact_dialogue != null: 
		await _start_dialogue(starting_interact_dialogue, starting_interact_dialogue_title, [self], dialogue_variation)
	
	
func _interaction_ending(interacted_by: Node, _interactable: Interactable = self) -> void: 
	if interacted_by.has_signal("interacted"): 
		interacted_by.interacted.emit(self)
	if call_world_event != "":
		WorldEventManager.call_event(call_world_event, interacted_by)
	if ending_interact_dialogue != null: 
		await _start_dialogue(ending_interact_dialogue, starting_interact_dialogue_title, [self], dialogue_variation)
	
	
func _interact(_interacted_by: Node, _interactable: Interactable = self) -> void:
	pass
	
	
func _touch_interact(_interacted_by: Node, _interactable: Interactable = self) -> void:
	pass


func _walk_in_interact(_interacted_by: Node, _interactable: Interactable = self) -> void:
	pass
	
	
func _interact_end(_interacted_by: Node, _interactable: Interactable = self) -> void: 
	pass
	
	
func save_data() -> Dictionary:
	var data: Dictionary = {
		"scene_file_path" : owner.scene_file_path,
		"position" : owner.position,
		"rotation" : owner.rotation, 
		"interact_count" : interact_count
	}
	var extra_save_data: Dictionary = _save_data()
	if !extra_save_data.is_empty():
		data.merge(extra_save_data, true)
	return data
	
	
func _save_data() -> Dictionary:
	var data: Dictionary = {}
	return data


func load_data(data: Dictionary) -> void: 
	var properties: PackedStringArray = data.keys()
	for property in properties: 
		self.set(property, data[property])


func _start_dialogue(dialogue: DialogueResource, title: String, extra_game_states: Array = [self], title_varation: int = 0, pause_game: bool = true): 
	dialogue_balloon_manager.set_dialogue_balloon(dialogue_balloon_manager.dialogue_box)
	dialogue_balloon_manager.start(dialogue, title, extra_game_states, title_varation, pause_game)
	await DialogueManager.dialogue_ended
