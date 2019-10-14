extends KinematicBody2D

var body_type = ""
var speed = 0
var health = 1
var damage = 0

var move_dir	= Vector2(0,0)		# direction of movement
var knock_dir	= Vector2(0,0)		# direction of knockback when hit
var sprite_dir	= "down"			# direction where sprite is facing

# timer when entity is stunned when nonzero (unit: frames)
var hit_stun = 0
var hit_stun_max = 10
var hit_stun_speed = 1.5

# allow for character properties to be modified
func _init(_speed = 0, _health=1, _body_type="enemy", _damage=0).():
	speed = _speed
	health = _health
	body_type = _body_type
	damage = _damage

func movement_loop():
	var motion
	if hit_stun == 0:
		motion = move_dir.normalized() * speed
	else:
		motion = knock_dir.normalized() * speed * hit_stun_speed
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
	if $anim.current_animation != animation_status:
		$anim.play(animation_status)

func damage_loop():
	if hit_stun > 0:
		hit_stun -= 1

	# check colliding areas, if different body_types then apply damage and hit_stun
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hit_stun == 0 and body.get("damage") != null and body.get("body_type") != body_type:
			health -= body.get("damage")
			hit_stun = hit_stun_max
			knock_dir = global_transform.get_origin() - body.global_transform.get_origin()
			
func use_item(item):
	var new_item = item.instance()		# creates new instance of item
	new_item.add_to_group(str(new_item.get_name(), self))	# adds new_item entity to a group
	add_child(new_item)
	if get_tree().get_nodes_in_group(str(new_item.get_name(), self)).size() > new_item.max_amount:
		new_item.queue_free()

