class_name BaseState
extends Node

@export var sound_effect: AudioStreamPlayer2D
@export var animation: StateMachineAnimationBase
## Only needed if the animation is a StateMachineDirectionAnimation
## If i put animation_tree in a resource, animation_tree.get doesn't work for some reason ( Returns Null )
@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer

var animation_direction: Vector2

# Pass in a reference to the state_machine_owner's character body so that it can be used by the state
@onready var state_machine: StateMachine
@onready var state_machine_owner: Node2D

func _ready() -> void: 
	if animation is StateMachineDirectionAnimation: 
		animation.animation_tree = animation_tree
		animation.state_machine = animation_tree.get("parameters/playback")


func init(_state_machine: StateMachine, _state_machine_owner: Node2D) -> void:
	state_machine = _state_machine
	state_machine_owner = _state_machine_owner


func enter() -> void: 
	if animation is StateMachineOneAnimation: 
		animation.play()
	elif animation is StateMachineDirectionAnimation: 
		animation.disabled = false


func exit() -> void:
	if animation is StateMachineDirectionAnimation: 
		animation.disabled = true


func input(_event: InputEvent) -> BaseState:
	return null


func process(_delta: float) -> BaseState:
	return null


func physics_process(_delta: float) -> BaseState: 
	if animation is StateMachineDirectionAnimation: 
		animation.play(animation_direction)
	return null


func set_owner_process_unhandled_input(value: bool) -> void:
	if !state_machine_owner.has_node("InputEventHandler"):
		return
	state_machine_owner.input_event_handler.disabled = value


func get_class_names() -> PackedStringArray: 
	return ["BaseState"]
	
	
