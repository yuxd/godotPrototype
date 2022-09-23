extends CharacterBody2D

@export var run_speed : float = 10.0
var held = null
var life = 100.0

var motion := Vector2(0, 0)
var blocked_time = 0.0
var target = null
var previous_position = Vector2(0, 0)

var world := get_parent()

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


func holds(object_type):
	if held != null and held.get_object_type() == object_type:
		return true
	return false


func pickup_object(object_type) -> bool:
	var nearest = find_nearest_object(object_type)
	if nearest.object == null or nearest.distance > 1.0:
		return false
	pickup(nearest.object)
	return true


func pickup(object):
	if held != null:
		get_parent().add_child(held)
		held.position = self.position
#		held.apply_impulse(Vector3(0.0, 0.0, 0.0), Vector3(0.0, 1.0, 1.0).rotated(Vector3(0.0, 1.0, 0.0), rotation.y))
		held.show()
	object.get_parent().remove_child(object)
	held = object
	world.update_held_icon()


func store_held(object_type) -> bool:
	if held != null and held.get_object_type() == object_type:
		held = null
		world.update_held_icon()
		return true
	else:
		return false


func pickup_nearest_object(object_type) -> bool:
	if holds(object_type):
		return false
	var object = find_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation)
	var ok :bool = await self.run_end
	if !ok:
		return false
	return pickup_object(object_type)


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


func use_nearest_object(object_type):
	var object = find_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation)
	var ok :bool = await self.run_end
	if !ok:
		return false
	return object.action(self)


func anim(a):
	var anim = $"AnimationPlayer"
	if anim.current_animation != a:
		anim.play(a)


func pickup_axe():
	return await pickup_nearest_object("axe")
	
func pickup_fruit():
	return await pickup_nearest_object("fruit")
	
func pickup_wood():
	return await pickup_nearest_object("wood")

func cut_tree():
	return await use_nearest_object("tree")
	
func store_wood():
	return await use_nearest_object("box")

func eat_fruit():
	if held != null and held.get_object_type() == "fruit":
		held.free()
		held = null
		world.update_held_icon()
		life += 20
		if life > 100: life = 100
		return true
	return false


func do_grow_tree():
	if held == null or held.get_object_type() != "fruit":
		return false
	held.free()
	held = null
	world.update_held_icon()
	var tree = preload("res://behavior_tree_demo/tree.tscn").instantiate()
	tree.position = self.position # + 2.0 * Vector2(sin(rotation.y), 0.0, cos(rotation.y))
	get_parent().add_child(tree)
	return true


func grow_tree():
	# Check we have a fruit
	if held == null or held.get_object_type() != "fruit":
		return false
	# Find a nice location for the tree
	var box = get_node("../Box")
	var p = null
	for i in range(5, 100, 5):
		for j in range(10):
			var test_p := Vector2(randf_range(-i, i), randf_range(-i, i))
			var ok = true
			for c in get_parent().get_children():
				if (c == box or c.has_method("get_object_type") and c.get_object_type().left(4) == "tree") and (c.translation - test_p).length() < 5.0:
					ok = false
			if ok:
				p = test_p
				break
		if p != null:
			break
	# return false if no location was found
	if p == null:
		return false
	# Try to run to location and return false uon failure
	run_to(p)
	var ok :bool = await self.run_end
	if !ok:
		return false
	# Destroy fruit and create growing tree
	return do_grow_tree()
