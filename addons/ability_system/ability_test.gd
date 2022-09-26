extends Sprite

onready var skill = preload("res://ability_01.tscn").instance()

func _ready():    
	print("sprite ready")    
	add_child(skill)
	skill.skill_level = 1

	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") :
		print(skill.skill_id)
		print(skill.skill_level)
		print("技能名称： ",skill._get_skill_title())
		print("技能输出： ",skill._get_skill_damage())
		print("技能描述： ",skill.get_desp_string())
		print("技能目标数： ", skill._get_skill_target_count())


	if Input.is_action_just_pressed("ui_page_up") :
		skill.skill_level += 1
		print("技能升级！")
