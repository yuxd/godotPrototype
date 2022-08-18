class_name LocomotionAnimationComponent
extends Node

const component_name := "C_LocomotionAnimation"

# Locomotion
@export var run_min_speed := 10.0

@export var air_animation := "Air"
@export var back_animation := "Back"
@export var climb_animation := "Climb"
@export var idle_animation := "idle"
@export var land_animation := "Land"
@export var run_animation := "run"
@export var walk_animation := "walk"

# TODO: Move this outside
@export var hit_animation := "Hit"
@export var punch_animation := "Punch"
@export var slash_animation := "Slash"
