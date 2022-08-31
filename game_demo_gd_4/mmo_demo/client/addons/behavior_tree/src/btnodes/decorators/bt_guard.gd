class_name BTGuard, "res://addons/behavior_tree/icons/btguard.svg"
extends BTDecorator

# Can lock the whole branch below itself. The lock happens either after the child ticks, 
# or after any other BTNode ticks. Then it stays locked for a given time, or until another
# specified BTNode ticks. You can set all this from the inspector.
# If you don't specify a locker, the lock_if variable will be based on the child.
# If you don't specify an unlocker, the unlock_if variable is useless and only the lock_time will 
# be considered, and viceversa.
# You can also choose to lock permanently or to lock on startup.
#
# A locked BTGuard will always return fail().

# 可以把整根树枝都锁在下面。锁发生在孩子发出 tick() 之后，
# 或者在任何其他BTNode滴答声之后。然后它会在给定的时间内保持锁定，或者直到下一个时间
# 指定的节点标记。你可以从检查员那里设置所有这些。
# 如果没有指定锁存器，则lock_If变量将基于子项。
# 如果未指定解锁器，则unlock_If变量无效，只有lock_time将无效
# 被考虑，反之亦然。
# 您还可以选择永久锁定或启动时锁定。
# 锁定的BTGuard将始终返回fail（）

@export var start_locked : bool = false
@export var permanent : bool = false
@export_node_path(Node) var _locker : NodePath
@export_enum("Failure", "Success", "Always") var lock_if : int
@export_node_path(Node) var _unlocker : NodePath
@export_enum("Failure", "Success") var unlock_if : int
@export var lock_time : float = 0.05

var locked: bool = false

@onready var unlocker: BTNode = get_node_or_null(_unlocker)
@onready var locker: BTNode = get_node_or_null(_locker)

func _ready():
	if start_locked:
		lock()
	
	if locker:
		locker.connect("tick", self._on_locker_tick)

func _on_locker_tick(_result):
	check_lock(locker)
	set_state(locker.state)

func lock():
	locked = true
	
	if debug:
		print(str(name) + " locked for " + str(lock_time) + " seconds")
	
	if permanent:
		return
	elif unlocker:
		while locked:
#			var result = yield(unlocker, "tick")
#			var result = unlocker.tick(agent, blackbord)
#			if result == bool(unlock_if):
#				locked = false
			pass
	else:
		await (get_tree().create_timer(lock_time, false).timeout)
		locked = false
	
	if debug:
		print(str(name) + " unlocked")

func check_lock(current_locker: BTNode):
	if ((lock_if == 2 and not current_locker.running()) 
	or ( lock_if == 1 and current_locker.succeeded()) 
	or ( lock_if == 0 and current_locker.failed())):
		lock()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	if locked:
		return fail()
	return super._tick(agent, blackboard)

func _post_tick(agent: Node, blackboard: Blackboard, result: bool) -> void:
	if not locker:
		check_lock(bt_child)
