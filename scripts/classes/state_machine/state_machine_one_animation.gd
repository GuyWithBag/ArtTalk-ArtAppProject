extends StateMachineAnimationBase
class_name StateMachineOneAnimation

@export var animation: String

func play() -> void: 
	animation_player.play(animation)
