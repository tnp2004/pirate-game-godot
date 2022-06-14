extends KinematicBody2D

var GRAVITY = 2000
var WALKSPEED = 1200
var FRICTION = 0.2
var JUMPFORCE = 700
var velocity = Vector2.ZERO
var stage_arr = ["attack_1", "attack_2", "attack_3", "air_attack_1", "air_attack_2", "air_attack_3"]
var is_dead = false
var player_flip = false
var max_player_energy = 100
var player_energy = max_player_energy
var regeneration_energy_per_second = 1

# for knockback
var repulsion = Vector2()
export(int) var player_knock_force = 5000

export(int) var attack_damage = 3
export(int) var health = 20

onready var stage_tree = get_node("AnimationTree")
onready var FSM = get_node("FiniteStateMachine")
onready var attack_area = get_node("attack_area/CollisionShape2D")
onready var animation_player = get_node("AnimationPlayer")

func _get_input_direction():
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = - JUMPFORCE
	velocity.x = direction * FRICTION * WALKSPEED
	
	if velocity.x == 0:
		$effect.visible = false
	
	if direction < 0: # left
		player_flip = true
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.offset.x = - 20
		$effect.flip_h = true
		$effect.offset.x = 10
		attack_area.position.x = - 105
	elif direction > 0: # right
		player_flip = false
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.offset.x = 0
		$effect.flip_h = false
		$effect.offset.x = 0
		attack_area.position.x = 47
		
	# air area attack
	if !is_on_floor():
		attack_area.position.y = 78.65
		$effect.visible = false
	else:
		attack_area.position.y = 6.36
	
	if velocity.x != 0 and is_on_floor() and !animation_player.current_animation in stage_arr:
		$effect.visible = true

func _physics_process(delta):
	print("energy = " ,player_energy)
	if !is_dead:
		velocity.y += GRAVITY * delta
		velocity = move_and_slide(velocity, Vector2.UP)

func _attack_input():
	if Input.is_action_just_pressed("attack_input"):
		if is_on_floor():
			if stage_tree.combo_stage == 1 and player_energy >= 10:
				player_energy -= 10
				FSM.set_state(FSM.states.attack_1)
			elif stage_tree.combo_stage == 2 and player_energy >= 15:
				player_energy -= 15
				FSM.set_state(FSM.states.attack_2)
			elif stage_tree.combo_stage == 3 and player_energy >= 20:
				player_energy -= 20
				FSM.set_state(FSM.states.attack_3)
		elif !is_on_floor():
			if stage_tree.combo_stage == 1 and player_energy >= 10:
				player_energy -= 10
				FSM.set_state(FSM.states.air_attack_1)
			elif stage_tree.combo_stage == 2 and player_energy >= 10:
				player_energy -= 10
				FSM.set_state(FSM.states.air_attack_2)

func check_anim_for_area():
	var now_stage = animation_player.current_animation
	if !now_stage in stage_arr:
		attack_area.disabled = true

func show_state_player_label():
	$Label.text = animation_player.current_animation

func dead():
	if health <= 0:
		is_dead = true
		FSM.set_state(FSM.states.dead)

func _set_hurt_state(knockback, knockback_air_height):
	FSM.set_state(FSM.states.hurt)
	velocity.x = 0
	repulsion.y = knockback_air_height
	repulsion.x = knockback
	move_and_slide(repulsion)

func _on_Regeneration_Energy_timeout():
	if player_energy < max_player_energy:
		player_energy += regeneration_energy_per_second
