extends CharacterBody2D

const SPEED = 100.0


var input_vector: = Vector2.ZERO


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"Move_State":
			input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			if input_vector != Vector2.ZERO:
				var direction_vector: = Vector2(input_vector.x, -input_vector.y)
				update_blend_position(direction_vector)
			
			if Input.is_action_just_pressed("attack"):
				playback.travel("Attack_State")
			
			if Input.is_action_just_pressed("taunt"):
				playback.travel("Taunt_State")
			
			velocity = input_vector * SPEED
			move_and_slide()
		"Attack_State":
			pass
		"Taunt_State":
			pass
		
func update_blend_position(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/Move_State/Walk/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/Move_State/Idle/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/Attack_State/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/Taunt_State/blend_position", direction_vector)
	
	
