class_name LocomotionSystem
extends Node

const entity_filter := ["CharacterBody2D"]
const system_name := "S_Locomotion"
const requirements = ["C_Locomotion"]

# move_and_slide parameters
@export var max_slides := 4
@export var infinite_inertia := true

func _system_init(_system_manager: SystemManager) -> bool:
	return true

func _system_physics_process(entities: Array, delta: float) -> void:
	for e in entities:
		var input: InputComponent = e.get_component("C_Input")
		var motion: LocomotionComponent = e.get_component("C_Locomotion")

		var velocity: Vector2 = motion.velocity
#		var acceleration: Vector2 = motion.acceleration
		var max_speed: Vector2 = motion.max_speed
		var direction: Vector2 = get_direction(input)
		if direction != Vector2.ZERO:
			direction = direction.normalized()
#			printerr(direction, e)
		if direction.x > 0:
			motion.facing = LocomotionComponent.Facing.RIGHT
		elif direction.x < 0:
			motion.facing = LocomotionComponent.Facing.LEFT
#		acceleration += gravity
		e.velocity =  Utils.calculate_velocity(velocity, max_speed, motion.speed, delta, direction)
		e.max_slides = max_slides
		velocity = e.velocity
#		e.infinite_inertia = infinite_inertia
		e.move_and_slide()
		# Apply FRICTION if no player input
		if direction.x == 0:
#			velocity.x = lerp(velocity.x, 0, friction * delta)
#			if abs(velocity.x) < 5:
				velocity = Vector2.ZERO
		motion.velocity = velocity
		if velocity != Vector2.ZERO:
			printerr(velocity)
#		motion.max_speed = max_speed

static func get_direction(input: InputComponent, _top_down := true) -> Vector2:
	if not input:
		return Vector2.ZERO if _top_down else Vector2(0, 1)
	var mu: int = 1 if input.is_action_pressed(Globals.InputAction.MOVE_UP) else 0
	var md: int = 1 if input.is_action_pressed(Globals.InputAction.MOVE_DOWN) else 0
	var mr: int = 1 if input.is_action_pressed(Globals.InputAction.MOVE_RIGHT) else 0
	var ml: int = 1 if input.is_action_pressed(Globals.InputAction.MOVE_LEFT) else 0
	return Vector2(mr - ml, md - mu) if _top_down else Vector2(mr - ml, 1)
