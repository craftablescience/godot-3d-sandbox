extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HBoxContainer/VBoxContainer2/ProgressBar.hide() # TODO
	$HBoxContainer/VBoxContainer2.hide()
	for button in $HBoxContainer/VBoxContainer.get_children():
		if (button is Button):
			button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load : String):
	if (scene_to_load == "QUIT"):
		get_tree().quit()
	else:
		$HBoxContainer/VBoxContainer2.show()
		get_tree().change_scene(scene_to_load)