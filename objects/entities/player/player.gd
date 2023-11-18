extends Entity
class_name Player

var player_name: StringName
var physics_process_started: bool = false

@onready var interact_cast: PlayerInteractShapeCast2D = get_node("PlayerInteractShapeCast2D")
@onready var equip_slots: EquipSlots = get_node("EquipSlots")
@onready var input_event_handler: Node = get_node("InputEventHandler")

# Every action the player has is handled in the StateMachine
# Every state is passed to the state machhine
func _ready() -> void: 
	input_event_handler.set_process_unhandled_input(false)
	
	
func _physics_process(delta: float) -> void:
	# This is done so that it avoids conflicts with the input handler still accepting inputs even when the scene is paused or just started
	if !physics_process_started: 
		
		# Initialize the state machine, passing a reference of the player to the state_machine,
		# that way they can move and react accordingly
		PlayerManager.init()
		state_machine.init(self)
		input_event_handler.set_process_unhandled_input(true)
		physics_process_started = true
	else: 
		state_machine.physics_process(delta)


func _process(delta: float) -> void: 
	if !physics_process_started: 
		return
	state_machine.process(delta)
	
	
func _save_data() -> Dictionary:
	var data: Dictionary = {
		"player_name" : player_name
	}
	data.merge(equip_slots.save_data(), true)
	return data


func die(): 
	super.die() 
	PlayerManager.death_count += 1


func get_class_names() -> PackedStringArray: 
	var classes: PackedStringArray = super.get_class_names()
	classes.append("Player")
	return classes
