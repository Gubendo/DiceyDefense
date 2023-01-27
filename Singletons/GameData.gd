extends Node


var soldier_stats: Dictionary = {
	1: {
		"damage": 8,
		"cooldown": 1.5,
		"range": 3,
	},
	2: {
		"damage": 8,
		"cooldown": 1,
		"range": 3,
	},
	3: {
		"damage": 10,
		"cooldown": 1,
		"range": 3.5,
	},
	4: {
		"damage": 12,
		"cooldown": 1,
		"range": 4,
	},
	5: {
		"damage": 15,
		"cooldown": 0.75,
		"range": 4,
	}
}

var archer_stats: Dictionary = {
	1: {
		"damage": 8,
		"cooldown": 1.5,
		"range": 8,
	},
	2: {
		"damage": 10,
		"cooldown": 1.5,
		"range": 8,
	},
	3: {
		"damage": 10,
		"cooldown": 1.25,
		"range": 10,
	},
	4: {
		"damage": 15,
		"cooldown": 1.25,
		"range": 10,
	},
	5: {
		"damage": 18,
		"cooldown": 1,
		"range": 14,
	}
}

var loup_stats: Dictionary = {
	1: {
		"bleed": 2,
		"freq": 1,
		"duration": 2,
		"cooldown": 1.5,
		"range": 4
	},
	2: {
		"bleed": 2,
		"freq": 1,
		"duration": 3,
		"cooldown": 1.25,
		"range": 4
	},
	3: {
		"bleed": 3,
		"freq": 0.75,
		"duration": 3,
		"cooldown": 1,
		"range": 5
	},
	4: {
		"bleed": 5,
		"freq": 0.75,
		"duration": 3,
		"cooldown": 1,
		"range": 5
	},
	5: {
		"bleed": 5,
		"freq": 0.5,
		"duration": 4,
		"cooldown": 0.75,
		"range": 6
	},
}

var bard_stats: Dictionary = {
	1: {
		"target": 1,
		"buff": 1.3,
		"duration": 2.5,
		"cooldown": 5,
		"range": 5
	},
	2: {
		"target": 1,
		"buff": 1.8,
		"duration": 3,
		"cooldown": 5,
		"range": 5
	},
	3: {
		"target": 2,
		"buff": 2,
		"duration": 3,
		"cooldown": 6,
		"range": 8
	},
	4: {
		"target": 2,
		"buff": 2,
		"duration": 4,
		"cooldown": 7,
		"range": 8
	},
	5: {
		"target": 3,
		"buff": 2.5,
		"duration": 5,
		"cooldown": 8,
		"range": 13.5
	}
}

var mage_stats: Dictionary = {
	1: {
		"damage": 2,
		"duration": 2,
		"cooldown": 1.5,
		"range": 8,
	},
	2: {
		"damage": 3,
		"duration": 3,
		"cooldown": 1.5,
		"range": 10,
	},
	3: {
		"damage": 5,
		"duration": 3,
		"cooldown": 1,
		"range": 10,
	},
	4: {
		"damage": 7,
		"duration": 3,
		"cooldown": 0.9,
		"range": 12,
	},
	5: {
		"damage": 8,
		"duration": 4,
		"cooldown": 0.75,
		"range": 14,
	}
}

var paladin_stats: Dictionary = {
	1: {
		"damage": 10,
		"cooldown": 1,
		"aoe": 40,
		"splash": 1,
		"range": 4
	},
	2: {
		"damage": 10,
		"cooldown": 1,
		"aoe": 40,
		"splash": 2,
		"range": 5
	},
	3: {
		"damage": 10,
		"cooldown": 1,
		"aoe": 40,
		"splash": 2,
		"range": 5
	},
	4: {
		"damage": 12,
		"cooldown": 1,
		"aoe": 40,
		"splash": 5,
		"range": 5
	},
	5: {
		"damage": 15,
		"cooldown": 0.8,
		"aoe": 40,
		"splash": 10,
		"range": 8
	}
}

var builder_stats: Dictionary = {
	1: {
		"health": 20,
		"damage": 5,
		"nb": 1,
		"range": -1
	},
	2: {
		"health": 20,
		"damage": 5,
		"nb": 2,
		"range": -1
	},
	3: {
		"health": 20,
		"damage": 10,
		"nb": 1,
		"range": -1
	},
	4: {
		"health": 20,
		"damage": 10,
		"nb": 2,
		"range": -1
	},
	5: {
		"health": 50,
		"damage": 10,
		"nb": 1,
		"range": -1
	},
	6: {
		"health": 50,
		"damage": 10,
		"nb": 2,
		"range": -1
	},
}

var bourreau_stats: Dictionary = {
	1: {
		"damage": 3,
		"cooldown": 1.5,
		"exec": 30,
		"range": 8
	},
	2: {
		"damage": 5,
		"cooldown": 1.5,
		"exec": 30,
		"range": 8
	},
	3: {
		"damage": 5,
		"cooldown": 1.2,
		"exec": 35,
		"range": 8
	},
	4: {
		"damage": 5,
		"cooldown": 1,
		"exec": 40,
		"range": 9
	},
	5: {
		"damage": 7,
		"cooldown": 1,
		"exec": 45,
		"range": 9
	},
	6: {
		"damage": 10,
		"cooldown": 0.8,
		"exec": 50,
		"range": 10
	},
}

var tavernier_stats: Dictionary = {
	1: {
		"buff_dmg": 1.25,
		"range": -1
	},
	2: {
		"buff_dmg": 1.5,
		"range": -1
	},
	3: {
		"buff_dmg": 1.75,
		"range": -1
	},
	4: {
		"buff_dmg": 2,
		"range": -1
	}
	
}

var catapulte_stats: Dictionary = {
	1: {
		"damage": 15,
		"cooldown": 3,
		"aoe": 15,
		"range": 15
	},
	2: {
		"damage": 16,
		"cooldown": 2.75,
		"aoe": 15,
		"range": 16
	},
	3: {
		"damage": 17,
		"cooldown": 2.5,
		"aoe": 15,
		"range": 17
	}
}

var trebuchet_stats: Dictionary = {
	1: {
		"damage": 25,
		"cooldown": 6,
		"aoe": 25,
		"range": 25
	},
	2: {
		"damage": 30,
		"cooldown": 5,
		"aoe": 25,
		"range": 25
	}
}

var colosse_stats: Dictionary = {
	1: {
		"damage": 40,
		"cooldown": 3,
		"range": 50
	},
	2: {
		"damage": 40,
		"cooldown": 15,
		"range": 50
	},
	3: {
		"damage": 50,
		"cooldown": 15,
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
		"bonus_roll": 3,
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
	"nexus_dmg": 2,
	"flying": false
}

var bobelin_stats: Dictionary = {
	"speed": 60,
	"health": 15,
	"damage": 0.5,
	"cd": 0.5,
	"nexus_dmg": 1,
	"flying": false
}

var banner_stats: Dictionary = {
	"speed": 12,
	"health": 30,
	"damage": 0.5,
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


var wave_data: Dictionary = { # [Nb of units, Name of unit + lvl, Time between units, Time after group]
	# TRIVIAL
	0: [[30, "Undead1", 1, 0, ]],
	# EASY
	1: [[5, "Undead1", 0.5, 0]],
	2: [[1, "Banner1", 0, 0.2], [10, "Gobelin1", 0.8, 0.5], [1, "Banner1", 0, 0.2], [5, "Gobelin1", 0.8, 0.5]],
	3: [[15, "Undead1", 0.5, 1.5], [5, "Bobelin1", 1, 0.5], [10, "Gobelin1", 0.5, 1.5]],
	# MEDIUM
	4: [[6, "Undead1", 0.5, 1], [1, "Beefy1", 0, 2], [6, "Undead1", 0.5, 1]],
	5: [[10, "Bobelin1", 0.3, 1.5], [10, "Gobelin1", 0.5, 0.1], [10, "Wisp1", 0.3, 1], [5, "Gobelin1", 0.5, 0.5]],
	6: [[6, "Wisp1", 0.5, 0.5], [30, "Gobelin1", 0.3, 0.5], [6, "Wisp1", 0.5, 0.5]],
	7: [[20, "Undead1", 0.5, 0.5], [1, "Beefy1", 0, 1], [10, "Undead1", 0.5, 0.5], [1, "Beefy1", 0, 1]],
	# HARD : BUFF HP ENNEMIS x 2 
	8: [[5, "Wisp2", 0.5, 5], [2, "Banner2", 1, 1], [1, "Beefy1", 0, 1.5], [20, "Undead2", 0.8, 0], [1, "Beefy2", 0, 1.5], [10, "Gobelin2", 0.5, 0]],
	9: [[30, "Gobelin2", 0.3, 3], [25, "Bobelin2", 0.5, 1], [12, "Undead2", 0.8, 0.2], [5, "Wisp2", 0.5, 3], [6, "Bobelin2", 0.5, 1]],
	# REALLY HARD
	10: [[6, "Banner2", 1.2, 1], [4, "Beefy2", 3, 0], [6, "Banner2", 1.2, 1]],
	11: [[50, "Undead2", 0.8, 1], [5, "Banner2", 1, 1], [1, "Beefy2", 0, 2], [5, "Banner2", 1, 1], [30, "Undead2", 0.8, 1], [25, "Gobelin2", 0.5, 1], [5, "Wisp2", 0.5, 1], [10, "Bobelin2", 1, 1], [25, "Gobelin2", 0.5, 1], [50, "Undead2", 0.8, 1]],
	# HARDCORE (NEED PERFECT COMP)
	12: [[1, "Boss", 0, 0]]
	
}
