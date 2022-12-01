extends TextureRect


@onready var base_texture: TextureRect = get_node(".")
@onready var highlight_texture: TextureRect = get_node("Highlight")

func _ready() -> void:
	base_texture.mouse_entered.connect(highlight.bind(true))
	base_texture.mouse_exited.connect(highlight.bind(false))
	
func highlight(value: bool) -> void:
	highlight_texture.visible = value
