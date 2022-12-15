extends Control

var save_system = SaveSystem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello")
	$VBoxContainer/Continue.grab_focus()
	focusIn($VBoxContainer/Continue)
	connect_signals()
	if not File.file_exists("user://save_file.save"):
		disable_resume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_signals() -> void:
	print("Je connecte les signaux")
	$VBoxContainer/Continue.pressed.connect(continueGame)
	$VBoxContainer/NewGame.pressed.connect(newGame)
	$VBoxContainer/Options.pressed.connect(options)
	$VBoxContainer/Quit.pressed.connect(quit)
	
	$VBoxContainer/Continue.mouse_entered.connect(focusButton.bind($VBoxContainer/Continue))
	$VBoxContainer/NewGame.mouse_entered.connect(focusButton.bind($VBoxContainer/NewGame))
	$VBoxContainer/Options.mouse_entered.connect(focusButton.bind($VBoxContainer/Options))
	$VBoxContainer/Quit.mouse_entered.connect(focusButton.bind($VBoxContainer/Quit))
	
	$VBoxContainer/Continue.focus_entered.connect(focusIn.bind($VBoxContainer/Continue))
	$VBoxContainer/NewGame.focus_entered.connect(focusIn.bind($VBoxContainer/NewGame))
	$VBoxContainer/Options.focus_entered.connect(focusIn.bind($VBoxContainer/Options))
	$VBoxContainer/Quit.focus_entered.connect(focusIn.bind($VBoxContainer/Quit))
	
	$VBoxContainer/Continue.focus_exited.connect(focusOut.bind($VBoxContainer/Continue))
	$VBoxContainer/NewGame.focus_exited.connect(focusOut.bind($VBoxContainer/NewGame))
	$VBoxContainer/Options.focus_exited.connect(focusOut.bind($VBoxContainer/Options))
	$VBoxContainer/Quit.focus_exited.connect(focusOut.bind($VBoxContainer/Quit))

	
func continueGame() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func newGame() -> void:
	save_system.reset_save()
	# LANCER CINEMATIQUE
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func quit() -> void:
	get_tree().quit()
	
func options() -> void:
	print("C'est les options !!")
	
func disable_resume() -> void:
	$VBoxContainer/NewGame.grab_focus()
	$VBoxContainer/Continue.disabled = true
	$VBoxContainer/NewGame.set_focus_neighbor(SIDE_TOP, "/root/Menu/VBoxContainer/Quit")
	$VBoxContainer/Quit.set_focus_neighbor(SIDE_BOTTOM, "/root/Menu/VBoxContainer/NewGame")
	
func focusButton(button: Button) -> void:
	button.grab_focus()
	
	
func focusIn(button: Button) -> void:
	print("IN" + str(button))
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1)
	
func focusOut(button: Button) -> void:
	print("OUT" + str(button))
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1, 1), 0.1)


