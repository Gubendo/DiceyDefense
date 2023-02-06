extends TextureRect

@onready var highlight_texture: TextureRect = $Highlight

func _ready() -> void:
	self.mouse_entered.connect(highlight.bind(true))
	self.mouse_exited.connect(highlight.bind(false))
	
func highlight(value: bool) -> void:
	highlight_texture.visible = value
	
func disconnect_signal() -> void:
	self.mouse_entered.disconnect(highlight.bind(true))
	self.mouse_exited.disconnect(highlight.bind(false))
