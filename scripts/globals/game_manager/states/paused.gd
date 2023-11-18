extends BaseState


func enter() -> void: 
	GameManager.pause_game(true)
	
	
func exit() -> void: 
	GameManager.pause_game(false)
	
	

