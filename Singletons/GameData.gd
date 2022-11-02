extends Node


var soldier_stats = {
	1: {
		"damage": 20,
		"cooldown": 0.5,
		"range": 3,
	}
}

var archer_stats = {
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

var loup_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var bard_stats = {
	1: {
		"target": 2,
		"buff": 2,
		"duration": 2,
		"cooldown": 3,
		"range": 5
	}
}

var mage_stats = {
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

var paladin_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var builder_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": -1
	}
}

var bourreau_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var tavernier_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var catapulte_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var trebuchet_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var colosse_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}

var charlatan_stats = {
	1: {
		"damage": 10,
		"cooldown": 0.5,
		"range": 5
	}
}



var unit_data = {
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


var wave_data = {
	0: [["Test", 1.5]],
	1: [["Test", 0.2], ["Test", 0.2], ["Test", 0.2], ["Test", 0.2]]
}
