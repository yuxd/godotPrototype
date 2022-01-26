# is in fact an FSM of the whole lifecycle of the game. 
# It'd be a very good habit to decouple different game states via procedures. 
# For a network game, you probably need procedures of checking resources, 
# updating resources, checking the server list, selecting a server, 
# logging in a server and creating avatars. 
# For a standalone game, you perhaps need to switch between procedures of the menu and the real gameplay. 
# The user could add procedures by simply subclassing and implementing the 'ProcedureBase' class
extends StateMachine
class_name ProcedureManager

