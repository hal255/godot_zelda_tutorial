extends "res://scripts/scripts_engine/entity.gd"

var state = "default"

# initialize player attributes inherited from entity.gd
func _init().(250, 100, "player", null):
	pass

# every time loop, run this function
func _physics_process(delta):
	match state:
		"default":
			state_default()
		"attack":
			state_attack()

# default state	
func state_default():
	control_loop()
	movement_loop()
	sprite_dir_loop()
	damage_loop()
	
	# animate push if collision is true from test_move
	# animation based on user input and direction of sprite
	if is_on_wall():
		if sprite_dir == "left" and test_move(transform, Vector2(-1,0)):
			anim_switch("push_left")
		if sprite_dir == "right" and test_move(transform, Vector2(1,0)):
			anim_switch("push_right")
		if sprite_dir == "up" and test_move(transform, Vector2(0,-1)):
			anim_switch("push_up")
		if sprite_dir == "down" and test_move(transform, Vector2(0,1)):
			anim_switch("push_down")
			
		# resolve bug where on wall, but not moving
		if move_dir == Vector2(0,0):
			anim_switch("idle_" + sprite_dir)
	# toggle walk/idle animation based on user input
	elif move_dir != Vector2(0,0):
		anim_switch("walk_" + sprite_dir)
	else:
		anim_switch("idle_" + sprite_dir)
		
	# if attack button is pressed, then load weapon
	if Input.is_action_just_pressed("ui_attack"):
		use_item(preload("res://items/weapons/sword.tscn"))

# if attack state, then restrict movement
func state_attack():
	anim_switch("idle_" + sprite_dir)
	damage_loop()

func control_loop():
	var LEFT	= Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A)
	var RIGHT	= Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D)
	var UP		= Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W)
	var DOWN	= Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)
	
	# handle motion where one direction does not overtake other
	move_dir.x	= -int(LEFT) + int(RIGHT)
	move_dir.y	= -int(UP) + int(DOWN)

