extends Control

signal pause()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap"):
		get_node("../Vague/Controls/PausePlay").button_pressed = !get_node("../Vague/Controls/PausePlay").button_pressed
		emit_signal("pause")

