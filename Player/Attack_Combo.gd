extends AnimationTree

var playback: AnimationNodeStateMachinePlayback
var combo_stage = 1
onready var combo_timer = get_parent().get_node("attack_timer")
onready var parent = get_parent()

func _ready():
	playback = get("parameters/playback")
	playback.start("attack_1")
	active = true

func _process(delta):
	#print(playback.get_current_node())
	pass

func _attack_tree():
	if Input.is_action_just_pressed("attack_input") and parent.velocity.y == 0:
		if combo_stage == 1:
			combo_stage += 1
			combo_timer.start()
			playback.travel("attack_1")
		elif combo_stage == 2:
			combo_stage += 1
			combo_timer.start()
			playback.travel("attack_2")
		elif combo_stage == 3:
			combo_stage = 1
			playback.travel("attack_3")
	elif Input.is_action_just_pressed("attack_input") and parent.velocity.y != 0:
		if combo_stage == 1:
			combo_stage += 1
			combo_timer.start()
			playback.travel("air_attack_1")
			print("air1")
		elif combo_stage == 2:
			combo_stage = 1
			playback.travel("air_attack_2")
			print("air2")

func _on_attack_timer_timeout():
	combo_stage = 1
