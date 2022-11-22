extends Node


var soldier_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 0.5,
		"range": 3,
	}
}

var archer_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 0.5,
		"range": 3,
	},
	2: {
		"damage": 30,
		"cooldown": 0.1,
		"range": 4,
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
		"buff": 2,
		"duration": 1,
		"cooldown": 3,
		"range": 5
	}
}

var mage_stats: Dictionary = {
	1: {
		"damage": 20,
		"cooldown": 0.1,
		"range": 3,
	},
	2: {
		"damage": 30,
		"cooldown": 0.1,
		"range": 4,
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
		"cooldown": 0.5,
		"aoe": 40,
		"splash": 5,
		"range": 5
	}
}

var builder_stats: Dictionary = {
	1: {
		"health": 5,
		"damage": 5,
		"nb": 2,
		"range": -1
	}
}

var bourreau_stats: Dictionary = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"exec": 50,
		"range": 10
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

var wave_data: Dictionary = { # [Nb of units, Name of unit, Time between units, Time after group]
	0: [[1, "Gobelin", 0, 0]],
	1: [[4, "Gobelin", 0.2, 1], [3, "Bobelin", 0.2, 0]],
	2: [[2, "Gobelin", 0.2, 1], [1, "Bobelin", 0, 0.2], [4, "Gobelin", 0.2, 0]]
}
