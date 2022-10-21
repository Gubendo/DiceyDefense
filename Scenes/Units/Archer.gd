extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Archer"

func _on_activate_pressed():
	activate()

func special():
	print("Je tire une flèche")
	target.take_dmg(GameData.unit_data["Archer"]["damage"])
