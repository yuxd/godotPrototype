extends CharacterBody2D

@export var run_speed : float = 10.0
var held = null
var life = 100.0

var motion := Vector2(0, 0)
var blocked_time = 0.0
var target = null
var previous_position = Vector2(0, 0)

signal run_end
signal action_end

func _physics_process(delta):
	life -= delta
	if life <= 0:
		set_physics_process(false)
		anim("Die")
		return
#	motion.y += -9.8 * delta
	self.velocity = motion
	self.up_direction = Vector2.ZERO
	move_and_slide()
	var direction = Vector2(0, 0)
	if target == null:
#		direction.y += run_speed*Input.get_joy_axis(0, 0)
#		direction.x -= run_speed*Input.get_joy_axis(0, 1)
#		if Input.is_action_pressed("ui_up"):
#			direction.x += run_speed
#		if Input.is_action_pressed("ui_down"):
#			direction.x -= run_speed
#		if Input.is_action_pressed("ui_left"):
#			direction.y -= run_speed
#		if Input.is_action_pressed("ui_right"):
#			direction.y += run_speed
		pass
	else:
		var remaining = Vector2(target.x, target.y) - Vector2(self.position.x, self.position.y)
		if remaining.length() < 0.8:
			target = null
			emit_signal("run_end", true)
			return
		else:
			direction = run_speed * (remaining).normalized()
	if direction.length() > run_speed:
		direction /= direction.length()
		direction *= run_speed
	var h_motion_influence = delta
	if is_on_floor():
		h_motion_influence *= 10
		motion.y = 0
		if Input.is_action_just_pressed("jump"):
			motion.y = 10
	var h_motion := Vector2(motion.x, motion.y)
	h_motion.x = lerp(h_motion.x, direction.x, h_motion_influence)
	h_motion.y = lerp(h_motion.y, direction.y, h_motion_influence)
	if (previous_position - self.position).length() / delta > 1:
		self.anim("Run")
#		rotation.y = 0.5*PI - h_motion.angle()
		blocked_time = 0.0
	else:
		self.anim("Idle")
		if (previous_position - position).length()/delta < 0.1:
			blocked_time += delta
			if blocked_time > 3.0:
				target = null
				emit_signal("run_end", false)
	previous_position = position
	motion.x = h_motion.x
	motion.y = h_motion.y


func run_to(p):
	blocked_time = 0.0
	target = p


func find_nearest_object(object_type = null):
	var nearest_distance = 100
	var nearest_object = null
	for o in $Detect.get_overlapping_bodies():
		if o.is_inside_tree() and o.translation.y < 0.5:
			var distance = (global_transform.origin - o.global_transform.origin).length()
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }


func update_held_icon():
	if held == null || name != "Player":
		$UI/Held.visible = false
	else:
		$UI/Held.visible = true
		$UI/Held.texture = load("res://goap_example/"+held.get_object_type()+"/"+held.get_object_type()+".png")

func anim(a):
	var anim = $"AnimationPlayer"
	if anim.current_animation != a:
		anim.play(a)
