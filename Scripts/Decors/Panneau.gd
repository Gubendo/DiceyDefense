extends Node2D

@onready var button: TextureButton = $TextureButton
@onready var sign_tooltip: Control = $CanvasLayer/Tooltip

func _ready() -> void:
	button.mouse_entered.connect(show_sign)
	button.mouse_exited.connect(clear_sign)
	
func _process(_delta: float) -> void:
	pass


func show_sign() -> void:
	sign_tooltip.visible = true
	
func clear_sign() -> void:
	sign_tooltip.visible = false
