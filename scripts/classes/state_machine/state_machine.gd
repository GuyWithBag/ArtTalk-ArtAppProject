extends Node
class_name StateMachine

signal entered_state(entered_state: BaseState)
signal exited_state(exited_state: BaseState)

signal changed_state(new_state: BaseState)

# Disabled, disables you to change state or handle input process, while disable_processes only disables the input process
@export var starting_state: BaseState
@export var disabled: bool = false
@export var disable_input_processes: bool = false

@export_group("DEBUGGING")
@export var debug: bool = false: 
	get: 
		if !OS.is_debug_build(): 
			return false
		return debug
@export var should_test_start_state: bool = false
@export var test_start_state: BaseState

var current_state: BaseState

@onready var states: Node = get_node("States")
@onready var current_state_label: Label = get_node("%CurrentStateLabel") if (has_node("%CurrentStateLabel")) else null


func _ready() -> void:
	if debug:
		print("%s's available states are: %s" % [get_parent().name, get_all_states()])


func get_all_states() -> Array[BaseState]:
	var _states: Array[BaseState] = []
	for state in states.get_children(): 
		if !(state is BaseState): 
			continue
		_states.append(state)
		var children: Array = state.get_children()
		if !children.is_empty(): 
			for state2 in children: 
				if !(state2 is BaseState): 
					continue
				_states.append(state2)
	return _states


func get_state(state_name: String) -> BaseState:
	var state: BaseState = null
	if states.has_node(state_name): 
		state = states.get_node(state_name)
	if state == null: 
		for state2 in states.get_children(): 
			if !(state2 is BaseState): 
				continue
			state = state2.get_node(state_name)
			if state != null: 
				break
	assert(state, "StateMachine (%s): %s state does not exist" % [owner, state_name])
	return state


func find_and_change_state(new_state_name: String) -> void:
	change_state(get_state(new_state_name))


func change_state(new_state: BaseState) -> void:
	if disabled:
		"StateMachine (%s): StateMachine is disabled" % [owner]
		return
	if !is_instance_valid(new_state): 
		printerr("StateMachine (%s): Change to new state is null. " % [owner])
		return
	if current_state:
		if debug:
			print("%s exited state %s" % [get_parent().name, current_state.name])
		current_state.exit()
		exited_state.emit(current_state)
		emit_signal("exited_state", current_state)

	current_state = new_state
	if debug:
		print("%s entered state %s" % [get_parent().name, current_state.name])
	current_state.enter()
	entered_state.emit(current_state)
	emit_signal("entered_state", current_state)
	changed_state.emit(current_state)
	if current_state_label:
		current_state_label.set_text(current_state.name)


func is_current_state(state: BaseState) -> bool: 
	if current_state == state: 
		return true
	return false

# This function is called from some other node's _init functions. 
# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(state_machine_owner: Node2D) -> void:
	for state in get_all_states():
		state.init(self, state_machine_owner)

	# Initialize with a default state of idle
	if is_instance_valid(test_start_state) && should_test_start_state: 
		change_state(test_start_state)
		return
	change_state(starting_state)
	
# Pass through functions for the state_machine_owner to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	if disabled:
		return
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func input(event: InputEvent) -> void:
	if disabled || disable_input_processes:
		return
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	if disabled:
		return
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
		
		
func save_data() -> Dictionary:
	var data: Dictionary = {
		"state_machine" : {
			"current_state" : current_state.name
		}
	}
	data["state_machine"]["get_all_states()"] = {}
	for state in get_all_states():
		if state.has_method("save_data"):
			data["state_machine"]["get_all_states()"][state.name] = state.save_data()
	if data["state_machine"]["get_all_states()"].is_empty(): 
		data["state_machine"].erase("get_all_states()")
		
	return data
	
	
func load_data(data: Dictionary) -> void: 
	var properties: PackedStringArray = data.keys()
	for property in properties: 
		if property == "get_all_states()": 
			var _all_states: Dictionary = data[property]
			for state_name in _all_states.keys(): 
				var state: BaseState = get_state(state_name)
				state.load_data(data)
			continue
		self.set(property, data[property])
	
	
