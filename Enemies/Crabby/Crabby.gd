extends KinematicBody2D

onready var FSM_enemy = get_node("FiniteStateMachine")

export(int) var speed: int = 0
export(int) var health = 10
export(int) var attack_damage = 2
export(int) var knock_force = 2000
export var is_attacking = false

var is_dead = false
var repulsion = Vector2()
var velocity: Vector2 = Vector2.ZERO
var gravity = 500
var is_moving_left = false

func _on_get_attack_area_area_entered(area):
	if area.name == "attack_area":
		var damage = area.get_parent().attack_damage
		health -= damage
		FSM_enemy.set_state(FSM_enemy.states.hurt)
		if health <= 0:
			$AttackDetector/CollisionShape2D.disabled = true
			$get_attack_area/CollisionShape2D.disabled = true
			is_dead = true
			$Attack_Crabby.stop()
			FSM_enemy.set_state(FSM_enemy.states.dead)

func _process(_delta):
	$Label.text = FSM_enemy.animation_player.current_animation
		
func move_character():
	velocity.x = -speed if is_moving_left else speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
		$Label.rect_scale.x = scale.x
	
func start_walk(): 
	$AnimationPlayer.play("move")

func _on_AttackDetector_body_entered(body):
	# damage for player
	if body.is_in_group("Player"):
		FSM_enemy.set_state(FSM_enemy.states.attack)
		var knockback = knock_force if !is_moving_left else - knock_force
		var knockback_air_height = - 500
		body.health -= attack_damage
		body._set_hurt_state(knockback, knockback_air_height)

func _knockback_when_get_attack():
	var knockback = knock_force if is_moving_left else - knock_force
	var knockback_air_height = 1000
	FSM_enemy.set_state(FSM_enemy.states.hurt)
	velocity.x = 0
	repulsion.x = knockback
	move_and_slide(repulsion)

func _on_Attack_Crabby_timeout():
	is_attacking = true
	FSM_enemy.set_state(FSM_enemy.states.attack)
