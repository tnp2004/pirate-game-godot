extends FiniteStateMachine

func _init():
	_add_state("hurt")
	_add_state("dead")
	_add_state("attack")
	_add_state("idle")
	
func _ready():
	set_state(states.idle)
	
func _state_logic(_delta: float) -> void:
	pass

func _get_transition() -> int:
	match state:
		states.idle:
			if !parent.is_dead:
				if parent.is_attacking:
					return states.attack
			else:
				return states.dead
		
		states.hurt:
			if !animation_player.is_playing():
				return states.idle
		
	return -1
	
func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.attack:
			animation_player.play("attack")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
