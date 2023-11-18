extends StateMachineAnimationBase
class_name StateMachineDirectionAnimation

@export var animation_name: String

var animation_playing: String
var animation_tree: AnimationTree
var state_machine: AnimationNodeStateMachinePlayback
var disabled: bool = false

func play(direction: Vector2) -> void: 
	if disabled: 
		return
	if state_machine: 
		state_machine.travel(animation_name)
		animation_tree["parameters/%s/blend_position" % animation_name] = direction
