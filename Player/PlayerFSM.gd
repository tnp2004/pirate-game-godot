extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("jump")
	_add_state("fall")
	_add_state("hurt")
	_add_state("dead")
	_add_state("sword_idle")
	_add_state("sword_move")
	_add_state("sword_jump")
	_add_state("sword_fall")
	_add_state("attack_1")
	_add_state("attack_2")
	_add_state("attack_3")
	_add_state("air_attack_1")
	_add_state("air_attack_2")

func _ready():
	set_state(states.sword_idle)

func _state_logic(_delta: float) -> void:
	parent.dead()
	if !parent.is_dead:
		parent._get_input_direction()
		parent.check_anim_for_area()
		if parent.player_energy != 0:
			parent._attack_input()
			parent.get_node("AnimationTree")._attack_tree()
	parent.show_state_player_label()

func _get_transition() -> int:
	match state:
		states.sword_idle:
			if parent.is_on_floor():
				if parent.velocity.length() > 0:
					if parent.velocity.y < 0:
						return states.sword_jump
					else:
						return states.sword_move
				elif parent.velocity.y < 0:
						return states.sword_jump
						
		states.sword_move:
			if parent.velocity.length() == 0:
				if parent.velocity.y < 0:
					return states.sword_jump
				else:
					return states.sword_idle
			elif parent.velocity.y < 0:
					return states.sword_jump
				
		states.sword_jump:
			if parent.is_on_floor():
				if parent.velocity.length() > 0:
					return states.sword_move
				else:
					return states.sword_idle
		
		states.hurt:
			if !animation_player.is_playing():
				return states.sword_idle
					
		# combo attack
		states.attack_1:
			if !animation_player.is_playing():
				return states.sword_idle
		states.attack_2:
			if !animation_player.is_playing():
				return states.sword_idle
		states.attack_3:
			if !animation_player.is_playing():
				return states.sword_idle
		
		# air attack
		states.air_attack_1:
			if !animation_player.is_playing():
				return states.sword_idle
		states.air_attack_2:
			if !animation_player.is_playing():
				return states.sword_idle
				
	return - 1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.sword_idle:
			animation_player.play("sword_idle")
		states.sword_move:
			animation_player.play("sword_move")
		states.sword_jump:
			animation_player.play("sword_jump")
		states.sword_fall:
			animation_player.play("sword_fall")
		states.attack_1:
			animation_player.play("attack_1")
		states.attack_2:
			animation_player.play("attack_2")
		states.attack_3:
			animation_player.play("attack_3")
		states.air_attack_1:
			animation_player.play("air_attack_1")
		states.air_attack_2:
			animation_player.play("air_attack_2")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
