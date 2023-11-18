extends BaseState
class_name PlayerBaseState

var idle_state: BaseState
var walk_state: BaseState
var run_state: BaseState
var open_inventory_state: BaseState
var interact_state: BaseState
var choosing_which_to_interact_state: BaseState
var interacting_state: PlayerInteractState
var interact_cooldown_timer: Timer

func init(_state_machine: StateMachine, _state_machine_owner: Node2D) -> void:
	super.init(_state_machine, _state_machine_owner)
	idle_state = state_machine.get_state("Idle")
	walk_state = state_machine.get_state("Walk")
	run_state = state_machine.get_state("Run")
	open_inventory_state = state_machine.get_state("OpenInventory")
	interact_state = state_machine.get_state("Interact")
	choosing_which_to_interact_state = state_machine.get_state("ChoosingWhichToInteract")
	interacting_state = state_machine.get_state("Interacting")
	interact_cooldown_timer = $"%InteractCooldown"


func input(_event: InputEvent) -> BaseState:
	var state_machine: StateMachine = GameManager.state_machine
	if state_machine.is_current_state(state_machine.get_state("Playing")): 
		if Input.is_action_just_pressed("open_inventory"):
			if state_machine.current_state != open_inventory_state: 
				return open_inventory_state
	return null

