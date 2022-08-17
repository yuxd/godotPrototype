class_name AnimationListenerSystem
extends System
# Listens for animation action signals and plays them with priority 1 by default

func _init() -> void:
	system_name = "S_AnimationListener"
	requirements = ["C_Sprite","C_AnimationPlayer"]

func _system_ready() -> void:
	system_manager.subscribe("play_animation", self.play_animation)

func _system_process(entities: Array, _delta: float) -> void:
	for e in entities:
		pass

func play_animation(entity: Entity, anim_name: String, animation_priority := 0) -> void:
	if not entity.meets_requirements(requirements):
		return
#	var anim_sprite: SpriteComponent = entity.get_component("C_Sprite")
	var animation_player : AnimationPlayerComponent = entity.get_component("C_AnimationPlayer")
	# Only play animations if current animation's priority is <= this system's.
#	if animation_player.priority <= animation_priority:
#		var prev_anim := animation_player.current_animation
##		var prev_frame := animation_player.frame
#		animation_player.priority = animation_priority
#		safe_play_animation(animation_player, anim_name)
#
#		# If the new animation is non-looping, then wait for the animation_finished signal and default back to playing our previous animation.
#		if (
#			animation_player.animation == anim_name
##			and not anim_sprite.frames.get_animation_loop(anim_name)
#		):
#			# check to make sure the priority hasn't gone up since we played the first animation and the animation hasn't changed on us
#			if animation_player.priority <= animation_priority and animation_player.animation == anim_name:
#				await animation_player.animation_finished
#				animation_player.play(prev_anim)
##				animation_player.frame = prev_frame
#				animation_player.priority = 0
	safe_play_animation(animation_player, anim_name)

static func safe_play_animation(anim: AnimationPlayerComponent, anim_name: String) -> void:
	if anim.has_animation(anim_name):
		anim.play(anim_name)
		printerr("safe_play_animation ", anim_name)
