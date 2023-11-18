extends Equipment

var on: bool = false

@onready var light_node: PointLight2D = get_node("../PointLight2D")

func _just_equipped() -> void:
	turn_on(true)


func use(used_by: Node):
	toggle_turn_on(used_by)
	
	
func toggle_turn_on(_used_by: Node) -> void:
	on = !on
	turn_on(on)


func turn_on(value: bool) -> void:
	light_node.enabled = value
