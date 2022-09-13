extends Node2D
class_name BattleEntity

@export var entity_id : String = ""
#export(Resource) var ability_config = preload("res://script/configs/abilities/ability_config_attack_001.tres")

@onready var ability_manager : BattleAbilityManager = $BattleAbilityManager
@onready var pb_health : ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer/pb_health
@onready var lab_health : Label = $PanelContainer/VBoxContainer/HBoxContainer/lab_health
@onready var pb_attack_interval : ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer2/pb_attack
@onready var lab_attack_interval : Label = $PanelContainer/VBoxContainer/HBoxContainer2/lab_attack
@onready var lab_name : Label = $PanelContainer/VBoxContainer/HBoxContainer3/lab_name
@onready var lab_test : Label = $lab_test

var entity_name : String = "battle_name"
var attack_timer : Timer = Timer.new()
var entity_config : BattleEntityConfig = BattleEntityConfig.new()

var max_health : AbilityAttribute
var current_health : AbilityAttribute

func _enter_tree():
	var entity_data = GameInstance.get_datatable_row(GameInstance.datatables.battle_entities, entity_id)
	entity_config.initialize_by_config(entity_data)

func _ready():
	_initialize_ability_manager()	
	_init_attack_timer()
	max_health = ability_manager.get_attribute(GameInstance.attributes.max_health)
	current_health = ability_manager.add_attribute(GameInstance.attributes.current_health, max_health.value, 0)
	pb_health.max_value = current_health.value
	lab_health.text = str(current_health.value) + "/" + str(max_health.value)
	current_health.connect("value_changed", _on_current_health_value_changed)
#	var ability = AbilityBase.new()
#	ability.initialize_by_config(ability_config, ability_manager)
#	ability_manager.give_ability(ability)
	pb_attack_interval.max_value = attack_timer.wait_time
	var atk : AbilityAttribute = ability_manager.get_attribute(GameInstance.attributes.attack_power)
	lab_test.text = "atk: " + str(atk.value)
	atk.connect("value_changed", _on_attack_power_value_changed)
	test_buff()
	
func test_buff():
	var buff_config : BuffConfig = load("res://script/battle_system/buff_test.tres")
	var buff = ability_manager.apply_buff_by_config(buff_config, self.ability_manager)

func _initialize_ability_manager():
	ability_manager.initialize_attribute_set_by_config(entity_config.attribute_set_config)
	for ability_config in entity_config.abilities:
		var ability : AbilityBase = AbilityBase.new()
		ability.initialize_by_config(ability_config, ability_manager)
		ability_manager.give_ability(ability)

func _init_attack_timer():
	var attack_interval = ability_manager.get_attribute(GameInstance.attributes.attack_interval)
	attack_timer.wait_time = attack_interval.value / 1000.0
#	attack_timer.autostart = true
	add_child(attack_timer)
	attack_timer.connect("timeout", _on_attack_timeout)

func get_random_enemy() -> BattleEntity:
	if owner == null : return null
	if not owner.has_method("get_random_enemy"): return null
	var enemy = owner.get_random_enemy(self)
#	print_debug("获取 随机 敌人： ", enemy)
	return enemy

func _process(delta):
	pb_attack_interval.value = attack_timer.time_left
	lab_attack_interval.text = str(snapped(attack_timer.time_left, 0.1)) # + "/" + str(ability_manager.attack_timer.wait_time)

func _on_current_health_value_changed(value : int):
	pb_health.value = value
	lab_health.text = str(current_health.value) + "/" + str(max_health.value)

func _on_attack_power_value_changed(value : int):
	lab_test.text = "atk: " + str(value)

func _on_attack_timeout():
	var attack_ability : AbilityBase = ability_manager.get_ability("attack")
#	var enemy = get_random_enemy()
#	if enemy != null:
#		ability_manager.try_active_ability(attack_ability, enemy.ability_manager)
	ability_manager.try_active_ability(attack_ability, self.ability_manager)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_E:
			var ability = ability_manager.get_ability("attack")
			ability_manager.try_active_ability(ability, self.ability_manager)
