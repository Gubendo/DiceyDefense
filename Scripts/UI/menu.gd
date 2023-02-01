extends Control

var save_system = SaveSystem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu/VBoxContainer/Continue.grab_focus()
	focusIn($MainMenu/VBoxContainer/Continue)
	connect_signals()
	if not FileAccess.file_exists("user://save_file.save"):
		disable_resume()
	$Settings/Popup.settings_open.connect(lock_input)
	$Settings/Popup.settings_close.connect(unlock_input)
	unlock_input()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func connect_signals() -> void:
	$MainMenu/VBoxContainer/Continue.pressed.connect(continueGame)
	$MainMenu/VBoxContainer/NewGame.pressed.connect(newGame)
	$MainMenu/VBoxContainer/Options.pressed.connect(options)
	$MainMenu/VBoxContainer/Quit.pressed.connect(quit)
	
	$MainMenu/VBoxContainer/Continue.mouse_entered.connect(focusButton.bind($MainMenu/VBoxContainer/Continue))
	$MainMenu/VBoxContainer/NewGame.mouse_entered.connect(focusButton.bind($MainMenu/VBoxContainer/NewGame))
	$MainMenu/VBoxContainer/Options.mouse_entered.connect(focusButton.bind($MainMenu/VBoxContainer/Options))
	$MainMenu/VBoxContainer/Quit.mouse_entered.connect(focusButton.bind($MainMenu/VBoxContainer/Quit))
	
	$MainMenu/VBoxContainer/Continue.focus_entered.connect(focusIn.bind($MainMenu/VBoxContainer/Continue))
	$MainMenu/VBoxContainer/NewGame.focus_entered.connect(focusIn.bind($MainMenu/VBoxContainer/NewGame))
	$MainMenu/VBoxContainer/Options.focus_entered.connect(focusIn.bind($MainMenu/VBoxContainer/Options))
	$MainMenu/VBoxContainer/Quit.focus_entered.connect(focusIn.bind($MainMenu/VBoxContainer/Quit))
	
	$MainMenu/VBoxContainer/Continue.focus_exited.connect(focusOut.bind($MainMenu/VBoxContainer/Continue))
	$MainMenu/VBoxContainer/NewGame.focus_exited.connect(focusOut.bind($MainMenu/VBoxContainer/NewGame))
	$MainMenu/VBoxContainer/Options.focus_exited.connect(focusOut.bind($MainMenu/VBoxContainer/Options))
	$MainMenu/VBoxContainer/Quit.focus_exited.connect(focusOut.bind($MainMenu/VBoxContainer/Quit))

	
func continueGame() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func newGame() -> void:
	save_system.reset_save()
	# LANCER CINEMATIQUE
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func quit() -> void:
	get_tree().quit()
	
func options() -> void:
	$Settings/Popup.open_window()
	
func disable_resume() -> void:
	$MainMenu/VBoxContainer/NewGame.grab_focus()
	$MainMenu/VBoxContainer/Continue.disabled = true
	$MainMenu/VBoxContainer/NewGame.set_focus_neighbor(SIDE_TOP, "/root/Menu/MainMenu/VBoxContainer/Quit")
	$MainMenu/VBoxContainer/Quit.set_focus_neighbor(SIDE_BOTTOM, "/root/Menu/MainMenu/VBoxContainer/NewGame")
	
func focusButton(button: Button) -> void:
	if not button.disabled:
		button.grab_focus()
	
	
func focusIn(button: Button) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	var original_size: Vector2 = button.get_size()
	tween.tween_property(button, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(button, "position:x", -42, 0.1)
	#tween.tween_property(button, "position:y", -42, 0.1)
	
func focusOut(button: Button) -> void:
	var tween: Tween = create_tween().set_parallel(true)

	var original_size: Vector2 = button.get_size()
	tween.tween_property(button, "scale", Vector2(1, 1), 0.1)
	tween.tween_property(button, "position:x", 0, 0.1)
	#tween.tween_property(button, "position:y", 0, 0.1)
	
func lock_input() -> void:
	$MainMenu/PauseOverlay.visible = true
	
func unlock_input() -> void:
	$MainMenu/PauseOverlay.visible = false


