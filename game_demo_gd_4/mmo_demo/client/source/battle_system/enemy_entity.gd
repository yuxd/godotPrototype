extends BattleEntity
class_name EnemyEntity

func _enter_tree():
	self.remove_from_group("mine")
	self.add_to_group("enemy")
