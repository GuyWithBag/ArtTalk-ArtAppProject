# Used to signal if the platform is changed. 
extends Node

signal platform_changed(new_platform: PlatformType, previous_platform: PlatformType)
signal touch_is_enabled

enum PlatformType {
	AUTO, 
	PC, 
	MOBILE, 
	CONSOLE
}

var touch_enabled = false: 
	set(value): 
		touch_enabled = value
		touch_is_enabled.emit()

@onready var current_platform_type: PlatformType = PlatformType.PC: 
	set(new_platform): 
		var previous_platform: PlatformType = current_platform_type
		current_platform_type = new_platform
		platform_changed.emit(new_platform, previous_platform) 

@onready var current_platform_type_string: String = PlatformType.keys()[current_platform_type]: 
	set(_value): 
		return
	get: 
		return PlatformType.keys()[current_platform_type]
		
		
func _ready() -> void: 
	UIManager.platform_init()
	appropriate_platform_to_os()
	
	
func appropriate_platform_to_os(override: PlatformType = PlatformType.AUTO) -> void: 
	if override != PlatformType.AUTO: 
		current_platform_type = override
		return
	match OS.get_name():
		"Windows", "UWP", "macOS":
			current_platform_type = PlatformType.PC
		"Android", "iOS":
			current_platform_type = PlatformType.MOBILE
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			print("Linux/BSD")


func is_pc() -> bool: 
	if current_platform_type == PlatformType.PC: 
		return true
	return false


func is_mobile() -> bool: 
	if current_platform_type == PlatformType.MOBILE: 
		return true
	return false
