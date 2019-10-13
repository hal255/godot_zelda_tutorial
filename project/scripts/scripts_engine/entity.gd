extends KinematicBody2D

var speed = 0
var health = 1

var move_dir = Vector2(0,0)
var sprite_dir = "down"

# allow for character properties to be modified
func _init(_speed = 0, _health=1).():
	speed = _speed
	health = _health

func movement_loop():
	var motion = move_dir.normalized() * speed
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
		# if move direction is down, then sprite is facing down
		Vector2(0,1):
			sprite_dir = "down"

func anim_switch(animation_status):
	if $animation_player.current_animation != animation_status:
		$animation_player.play(animation_status)
