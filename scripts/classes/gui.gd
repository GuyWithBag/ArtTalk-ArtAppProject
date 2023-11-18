# All gui related things that can be controled by the UIManager. 
# All code that shows the gui must start at set_active(), also so it is less prone to bugs. 
extends Control 
class_name GUI

signal activated 
signal deactivated

# GUIType are for identifying what types of guis are focused. 

enum GUIType {
	PAUSE_MENU, 
	PLAYER_GUI, 
	TUTORIAL, 
	CINEMATIC, 
	# Widget is a type that can be added whatever gui_type is focused. 
	WIDGET 
} 

var active: bool = false: set = set_active

@export var disabled: bool = false
@export var gui_type: GUIType


func set_active(value: bool) -> void: 
	if disabled: 
		return
	visible = value 
	active = visible
	if value == true: 
		activated.emit()
	else: 
		deactivated.emit()
	
	
