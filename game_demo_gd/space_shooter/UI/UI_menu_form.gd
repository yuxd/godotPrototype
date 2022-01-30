extends UIFormBase


onready var btn_start_game = $btn_start_game
onready var btn_quit_game = $btn_quit_game
var _procedure_manager : ProcedureManager

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_start_game.connect("pressed",self,"_on_start_game_btn_pressed")
	btn_quit_game.connect("pressed",self,"_on_quit_game_btn_pressed")
	_procedure_manager = QInstance.get_procedure_manager()

func _on_start_game_btn_pressed():
	_procedure_manager.get_current_procedure().start_game()

func _on_quit_game_btn_pressed():
	get_tree().quit()
