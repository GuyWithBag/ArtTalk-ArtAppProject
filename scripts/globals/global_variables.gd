extends Node

const UNIT_SIZE: int = 64 

const BASE_SPEED: float = 2.8
## This is mainly use so that i can scale it with the AnimationPlayer speed
## Also called as the default speed for all characters
## 5 (entity scaled_move_speed) / SCALED_BASE_SPEED
const SCALED_BASE_SPEED: float = BASE_SPEED * UNIT_SIZE


func get_tile_scaled_speed(speed: float) -> float: 
	return speed * UNIT_SIZE
