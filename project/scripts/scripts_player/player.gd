extends KinematicBody2D

const SPEED = 250

var move_dir = Vector2(0,0)

# every time loop, run this function
func _physics_process(delta):
	control_loop()
	movement_loop()

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
