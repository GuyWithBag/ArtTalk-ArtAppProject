@tool
extends Node

@export var tool_generate_id: bool:
	set(_value):
		generate_id()
		tool_generate_id = false

func generate_id() -> int:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var new_id: int = rng.randi_range(1000, 9999)
	print("Here is a new ID: %s" % new_id)
	return new_id
	
	
