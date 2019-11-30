extends Spatial


enum PLAYER_TYPES {player, freecam}

var Player_Scene : PackedScene = preload("res://scenes/Player.tscn")
var Freecam_Scene : PackedScene = preload("res://scenes/Freecam.tscn")
var Pickup_Scene : PackedScene = preload("res://models/Pickup.tscn")
var Player : KinematicBody
var Freecam
var Pickup : RigidBody

export var START_POS := Vector3(0, 0, 10)
export var DEFAULT_PLAYER := PLAYER_TYPES.player
var CURRENT_PLAYER := DEFAULT_PLAYER


func _ready() -> void:
	Player = Player_Scene.instance()
	Player.translation = $SpawnPoint_Player.translation
	Freecam = Freecam_Scene.instance()
	Freecam.translation = START_POS
	Pickup = Pickup_Scene.instance()
	Pickup.translation = $SpawnPoint_Pickup.translation
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_tree().set_auto_accept_quit(false)    # Makes it so pressing [X] does not close

	if DEFAULT_PLAYER == PLAYER_TYPES.player:
		add_child(Player)
	elif DEFAULT_PLAYER == PLAYER_TYPES.freecam:
		add_child(Freecam)
	
	add_child(Pickup)


func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_exit"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	
	if (Pickup.PLAYER_IN_CAB and Pickup.ENABLED) and (Player.get_parent().name != "Pickup"):
		var playerrot : Vector3 = Player.get_global_transform().basis.get_euler()
		playerrot.y -= Pickup.get_global_transform().basis.get_euler().y
		remove_child(Player)
		Pickup.add_child(Player)
		Player.set_pos(Vector3(-2.5,2,0))
		Player.set_rotation(playerrot)
	if (not Pickup.ENABLED) and (Player.get_parent().name != "World"):
		var playerpos : Vector3 = Player.get_global_transform().origin
		var playerrot : Vector3 = Player.get_global_transform().basis.get_euler()
		playerrot.x = 0.0
		playerrot.z = 0.0
		Pickup.remove_child(Player)
		add_child(Player)
		Player.set_pos(playerpos)
		Player.set_rotation(playerrot)

# HTML5 ONLY
func _input(ev) -> void:
	if ev is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
# HTML5 ONLY

	"""# !TODO!
	if Input.is_action_just_pressed("debug_noclip_swap"):
		if CURRENT_PLAYER == PLAYER_TYPES.player:
			Freecam.translate = Player.get_()
			remove_child(Player)
			add_child(Freecam)
			CURRENT_PLAYER = PLAYER_TYPES.freecam
			
		elif CURRENT_PLAYER == PLAYER_TYPES.freecam:
			Player.set_pos(Freecam.translate)
			remove_child(Freecam)
			add_child(Player)
			CURRENT_PLAYER = PLAYER_TYPES.player"""