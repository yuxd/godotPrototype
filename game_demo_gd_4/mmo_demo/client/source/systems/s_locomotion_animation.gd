class_name LocomotionAnimationSystem
extends System

@export var animation_priority := 0

func _init() -> void:
	system_name = "S_LocomotionAnimation"
	requirements = ["C_Sprite", "C_Locomotion", "C_LocomotionAnimation"]

func _system_process(entities: Array, _delta: float) -> void:
	for e in entities:
		var anim: LocomotionAnimationComponent = e.get_component("C_LocomotionAnimation")
		var anim_sprite: SpriteComponent = e.get_component("C_Sprite")
		var motion: LocomotionComponent = e.get_component("C_Locomotion")

		match motion.facing:
			LocomotionComponent.Facing.LEFT:
				anim_sprite.flip_h = true
			LocomotionComponent.Facing.RIGHT:
				anim_sprite.flip_h = false
			LocomotionComponent.Facing.UP:
				anim_sprite.flip_h = false
			_:
				pass

		if motion.velocity.length() >= anim.run_min_speed:
			system_manager.emit("play_animation", [e, anim.run_animation, 0])
		elif motion.velocity.length() > 0:
			system_manager.emit("play_animation", [e, anim.walk_animation, 0])
		else:
			system_manager.emit("play_animation", [e, anim.idle_animation, 0])
