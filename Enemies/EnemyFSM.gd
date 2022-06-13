extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("jump")
	_add_state("fall")
	_add_state("hurt")
	_add_state("dead")
	_add_state("attack")
	
func _ready():
	set_state(states.idle)
	
func _state_logic(_delta: float) -> void:
	if animation_player.current_animation != "attack" and !parent.is_dead:
		parent.move_character()
		parent.detect_turn_around()

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.velocity.length() > 0:
					if parent.velocity.y < 0:
						return states.jump
					else:
						return states.move
				elif parent.velocity.y < 0:
						return states.jump
		states.move:
			if parent.velocity.length() == 0:
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.idle
			elif parent.velocity.y < 0:
					return states.jump
		states.jump:
			if parent.is_on_floor():
				if parent.velocity.length() > 0:
					return states.move
				else:
					return states.idle
		states.hurt:
			if !animation_player.is_playing():
				return states.idle
		states.attack:
			if !animation_player.is_playing():
				return states.idle
				
	return -1
	
func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.jump:
			animation_player.play("jump")
		states.fall:
			animation_player.play("fall")
		states.attack:
			animation_player.play("attack")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
