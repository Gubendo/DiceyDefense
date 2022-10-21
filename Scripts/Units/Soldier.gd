extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Soldier"


func _on_activate_pressed():
	activate()

func special():
	print("Je donne un coup d'épée")
	target.take_dmg(GameData.unit_data["Soldier"]["damage"])
