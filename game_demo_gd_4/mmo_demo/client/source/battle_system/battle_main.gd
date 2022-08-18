extends Node

#onready var battle_prefab : PackedScene = preload("res://scenes/combat_entity.tscn")
#onready var enemy_prefab = preload("res://scenes/enemy_entity.tscn")

func _ready():
#	var battle_entity = battle_prefab.instance()
#	add_child(battle_entity)
#	var enemy_entity = enemy_prefab.instance()
#	add_child(enemy_entity)
	pass

func get_all_enemy(entity : BattleEntity) -> Array:
	var enemy : Array = []
	if entity.is_in_group("mine"):
		for child in get_children():
			if child.is_in_group("enemy"):
				enemy.append(child)
	elif entity.is_in_group("enemy"):
		for child in get_children():
			if child.is_in_group("mine"):
				enemy.append(child)
	return enemy

func get_random_enemy(entity : BattleEntity) -> BattleEntity:
	var enemys = get_all_enemy(entity)
	if enemys.size() <= 0 : return null
	var ri = randi() % enemys.size()
	return enemys[ri]
