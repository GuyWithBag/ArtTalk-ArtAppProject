extends PlayerBaseState


@onready var player_inventory_gui: InventoryUI = UIManager.player_inventory


func enter():
	super.enter()
	UIManager.set_gui_active(player_inventory_gui, true)
	
	
func exit():
	# To unopen inventory/change state to walk will be in PlayerInventoryUI
	super.exit()
	UIManager.set_gui_active(player_inventory_gui, false)


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("open_inventory"): 
		return idle_state
	elif Input.is_action_just_pressed("ui_cancel"):
		return idle_state
		
	if Input.is_action_just_pressed("interact"):
		return idle_state # Pressing of the options is handled in PlayerInteractOptions by setting the focused option's shortuct key in interact. 
	return null

