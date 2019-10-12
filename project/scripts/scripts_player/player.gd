extends KinematicBody2D

const SPEED = 250

var move_dir = Vector2(0,0)

var sprite_dir = "down"

# every time loop, run this function
func _physics_process(delta):
	control_loop()
	movement_loop()
	sprite_dir_loop()
	
	# animate push if collision is true from test_move
	# animation based on user input and direction of sprite
	if is_on_wall():
		if sprite_dir == "left" and test_move(transform, Vector2(-1,0)):
			anim_switch("push")
		if sprite_dir == "right" and test_move(transform, Vector2(1,0)):
			anim_switch("push")
		if sprite_dir == "up" and test_move(transform, Vector2(0,-1)):
			anim_switch("push")
		if sprite_dir == "down" and test_move(transform, Vector2(0,1)):
			anim_switch("push")
	# toggle walk/idle animation based on user input
	elif move_dir != Vector2(0,0):
		anim_switch("walk")
	else:
		anim_switch("idle")
		
		

func control_loop():
	var LEFT	= Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A)
	var RIGHT	= Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D)
	var UP		= Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W)
	var DOWN	= Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)
	
	# handle motion where one direction does not overtake other
	move_dir.x	= -int(LEFT) + int(RIGHT)
	move_dir.y	= -int(UP) + int(DOWN)

func movement_loop():
	var motion = move_dir.normalized() * SPEED
	move_and_slide(motion, Vector2(0,0))

func sprite_dir_loop():
	# match is similar like switch-statements (series of if-statements)
	match move_dir:
		# if move direction is left, then sprite is facing left
		Vector2(-1,0):
			sprite_dir = "left"
		# if move direction is right, then sprite is facing right
		Vector2(1,0):
			sprite_dir = "right"
		# if move direction is up, then sprite is facing up
		Vector2(0,-1):
			sprite_dir = "up"
		# Match default (denoted as _) is facing down
		_:
			sprite_dir = "down"

func anim_switch(animation):
	var new_anim = str(animation.sprite_dir)
	if $animation_player.current_animation != new_anim:
		$animation_player.play(new_anim)
