extends PlayerBaseState
class_name PlayerInteractState

@export var interact_cast: PlayerInteractShapeCast2D

var colliders_label_text: String = "Colliders: %s"

@onready var colliders_label: Label = %Colliders
@onready var player_interact_options: GUI = UIManager.player_interact_options

