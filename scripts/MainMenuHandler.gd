extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for button in $VBoxContainer.get_children():
		if (button is Button):
			button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load : String):
	if (scene_to_load == "QUIT"):
		get_tree().quit()
	else:
		get_tree().change_scene(scene_to_load)