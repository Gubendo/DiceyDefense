extends Node2D

@onready var button: TextureButton = $TextureButton
@onready var sign: Control = $CanvasLayer/Tooltip

func _ready() -> void:
	button.mouse_entered.connect(show_sign)
	button.mouse_exited.connect(clear_sign)
	
func _process(delta: float) -> void:
	pass


func show_sign() -> void:
	sign.visible = true
	
func clear_sign() -> void:
	sign.visible = false
