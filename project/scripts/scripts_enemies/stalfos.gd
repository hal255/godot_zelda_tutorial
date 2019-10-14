extends "res://scripts/scripts_engine/entity.gd"

# initialize enemy attributes inherited from entity.gd
func _init().(250, 100, "enemy", 1):
	pass

# forces enemy to switch random movement every 15 frames
var move_timer_length = 15
var move_timer = 0

func _ready():
	$anim.play("move_down")
	# set move direction as the randomly generated direction from engine
	move_dir = engine_directions.rand_dir()
	
func _physics_process(delta):
	movement_loop()
	damage_loop()
	
	if move_timer > 0:
		move_timer -= 1
	if move_timer <= 0 || is_on_wall():
		move_dir = engine_directions.rand_dir()
		move_timer = move_timer_length
