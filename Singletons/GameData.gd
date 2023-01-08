extends Node


var soldier_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 1,
		"range": 3.5,
	},
	2: {
		"damage": 20,
		"cooldown": 1,
		"range": 3,
	},
	3: {
		"damage": 10,
		"cooldown": 1,
		"range": 3,
	}
}

var archer_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 0.5,
		"range": 10,
	},
	2: {
		"damage": 30,
		"cooldown": 0.1,
		"range": 10,
	},
	3: {
		"damage": 40,
		"cooldown": 0,
		"range": 10,
	}
}

var loup_stats: Dictionary = {
	1: {
		"bleed": 10,
		"freq": 1,
		"duration": 3,
		"cooldown": 0.5,
		"range": 5
	}
}

var bard_stats: Dictionary = {
	1: {
		"target": 2,
		"buff": 5,
		"duration": 3,
		"cooldown": 6,
		"range": 8
	}
}

var mage_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 1,
		"range": 10,
	},
	2: {
		"damage": 30,
		"cooldown": 0.1,
		"range": 10,
	},
	3: {
		"damage": 40,
		"cooldown": 0.1,
		"range": 10,
	}
}

var paladin_stats: Dictionary = {
	1: {
		"damage": 10,
		"cooldown": 1,
		"aoe": 40,
		"splash": 5,
		"range": 5
	}
}

var builder_stats: Dictionary = {
	1: {
		"health": 20,
		"damage": 5,
		"nb": 2,
		"range": -1
	}
}

var bourreau_stats: Dictionary = {
	1: {
		"damage": 15,
		"cooldown": 0.5,
		"exec": 50,
		"range": 20
	}
}

var tavernier_stats: Dictionary = {
	1: {
		"buff_dmg": 2,
		"range": -1
	},
	2: {
		"buff_dmg": 2.5,
		"range": -1
	},
	3: {
		"buff_dmg": 3,
		"range": -1
	}
	
}

var catapulte_stats: Dictionary = {
	1: {
		"damage": 10,
		"cooldown": 1,
		"aoe": 40,
		"range": 10
	}
}

var trebuchet_stats: Dictionary = {
	1: {
		"damage": 40,
		"cooldown": 3,
		"aoe": 40,
		"range": 25
	}
}

var colosse_stats: Dictionary = {
	1: {
		"damage": 40,
		"cooldown": 3,
		"range": 50
	}
}

var charlatan_stats: Dictionary = {
	1: {
		"bonus_roll": 0,
		"range": -1
	},
	2: {
		"bonus_roll": 1,
		"range": -1
	},
	3: {
		"bonus_roll": 2,
		"range": -1
	},
	4: {
		"bonus_roll": 10,
		"range": -1
	}
}



var unit_data: Dictionary = {
	"Soldier": {
		"value": "total1",
		"stats": soldier_stats
	},
	"Archer": {
		"value": "total2",
		"stats": archer_stats
	},
	"Loup": {
		"value": "total3",
		"stats": loup_stats
	},
	"Bard": {
		"value": "total4",
		"stats": bard_stats
	},
	"Mage": {
		"value": "total5",
		"stats": mage_stats
	},
	"Paladin": {
		"value": "total6",
		"stats": paladin_stats
	},
	"Builder": {
		"value": "brelan",
		"stats": builder_stats
	},
	"Bourreau": {
		"value": "carre",
		"stats": bourreau_stats
	},
	"Tavernier": {
		"value": "full",
		"stats": tavernier_stats
	},
	"IngeJR": {
		"value": "p_suite",
		"stats": catapulte_stats
	},
	"IngeSR": {
		"value": "g_suite",
		"stats": trebuchet_stats
	},
	"Colosse": {
		"value": "yams",
		"stats": colosse_stats
	},
	"Charlatan": {
		"value": "chance",
		"stats": charlatan_stats
	}
	
}

var gobelin_stats: Dictionary = {
	"speed": 20,
	"health": 35,
	"damage": 1,
	"cd": 1,
	"nexus_dmg": 1,
	"flying": false
}

var bobelin_stats: Dictionary = {
	"speed": 60,
	"health": 15,
	"damage": 1,
	"cd": 1,
	"nexus_dmg": 2,
	"flying": false
}

var banner_stats: Dictionary = {
	"speed": 12,
	"health": 30,
	"damage": 1,
	"cd": 1,
	"nexus_dmg": 1,
	"flying": false
}

var undead_stats: Dictionary = {
	"speed": 15,
	"health": 40,
	"damage": 1,
	"cd": 1,
	"nexus_dmg": 1,
	"flying": false
}

var wisp_stats: Dictionary = {
	"speed": 25,
	"health": 20,
	"damage": 0,
	"cd": 0,
	"nexus_dmg": 1,
	"flying": true
}

var beefy_stats: Dictionary = {
	"speed": 10,
	"health": 500,
	"damage": 20,
	"cd": 5,
	"nexus_dmg": 1,
	"flying": false
}

var enemies_stats: Dictionary = {
	"Gobelin": gobelin_stats,
	"Bobelin": bobelin_stats,
	"Banner": banner_stats,
	"Undead": undead_stats,
	"Wisp": wisp_stats,
	"Beefy": beefy_stats
}


var wave_data: Dictionary = { # [Nb of units, Name of unit, Time between units, Time after group]
	0: [[6, "Wisp", 0.5, 0]],
	#0: [[1, "Beefy", 0, 0.5], [5, "Undead", 1, 0]],
	#1: [[4, "Gobelin", 1, 1], [5, "Bobelin", 0.4, 0]],
	#2: [[2, "Gobelin", 1, 1], [1, "Bobelin", 0, 0.2], [4, "Gobelin", 1, 0]]
}
