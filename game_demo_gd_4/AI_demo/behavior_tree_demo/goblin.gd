extends CharacterBody2D
class_name PlayerCharacter

@onready var world : World = get_parent()

@export var run_speed : float = 10.0
var held = null
var life = 100.0

var motion := Vector2(0, 0)
var target = null
var face : bool = true

signal run_end
signal action_end

@onready var sprite : Sprite2D = $Sprite2d

func _physics_process(delta):
	_run(delta)
	life -= delta
	sprite.flip_h = face
	if life <= 0:
		set_physics_process(false)
		anim("Die")
		return


func _run(delta):
	if target == null:
#		print_debug("移动目标为空！")
		return
	
	face = true if self.position.x > target.position.x else false
	var target_position := Vector2( ((target.position.x + 16) if self.position.x > target.position.x else (target.position.x - 16) ) \
		, target.position.y)
	$NavigationAgent2d.set_target_location(target_position)
	var next_location : Vector2 = $NavigationAgent2d.get_next_location()
#	print_debug("目标位置：" , target_position, "当前所在位置： ", position , "下一个移动位置： " ,  \
#		next_location, "距离目标点距离：" ,position.distance_to(target_position))
	if self.position.distance_to(target_position) > 1:
		self.velocity = position.direction_to(next_location) * run_speed
		self.anim("Run")
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		target = null
		self.anim("Idle")		
		emit_signal("run_end", false)


func run_to(p):
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
	var nearest_distance = 1000
	var nearest_object = null
	for o in world.game_objects:
		if o.is_inside_tree():
			var distance = (self.position - o.position).length()
			if o != self and o.get_script() != null and (object_type == null \
				or o.get_object_type() == object_type) and distance < nearest_distance:
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
