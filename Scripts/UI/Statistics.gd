extends Container

signal stats_open
signal stats_close

var open: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	close_window()
	rng.randomize()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap") and open:
		close_window()

func close_window() -> void:
	get_parent().visible = false
	open = false
	emit_signal("stats_close")
	
func open_window() -> void:
	update_stats()
	get_parent().visible = true
	open = true
	emit_signal("stats_open")
	
func update_stats() -> void:
	$Header/Scores/Vague.text = "Vagues terminées : " + str($/root/Main.current_wave) + "/13"
	$Header/Scores/Score.text = "Score global : " + str($/root/Main/YamsManager.global_score)
	
	$"Header/Window/Tabs/Unités/List/Soldier/Stats/Damage".text = "Dégats infligés : " + str($/root/Main/Units/Soldier.damage_dealt)
	
	
	$"Header/Window/Tabs/Unités/List/Tavernier/Stats/Glasses".text = "Verres nettoyés : " + str(rng.randi_range($/root/Main.current_wave + 1, ($/root/Main.current_wave + 1)*10))



