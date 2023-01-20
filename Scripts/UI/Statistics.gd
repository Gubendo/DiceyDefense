extends Container

signal stats_open
signal stats_close

var open: bool = false

func _ready() -> void:
	close_window()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap") and open:
		close_window()

func close_window() -> void:
	get_parent().visible = false
	open = false
	emit_signal("stats_close")
	
func open_window() -> void:
	get_parent().visible = true
	open = true
	emit_signal("stats_open")




