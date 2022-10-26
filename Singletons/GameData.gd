extends Node


var soldier_stats = {
	0: {
		"damage": 10,
		"cooldown": 1,
		"range": 2,
	},
	1: {
		"damage": 20,
		"cooldown": 0.5,
		"range": 3,
	}
}

var archer_stats = {
	0: {
		"damage": 10,
		"cooldown": 1,
		"range": 2,
	},
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

var mage_stats = {
	0: {
		"damage": 10,
		"cooldown": 0.1,
		"range": 2,
	},
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
	0: {
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
	"Mage": {
		"value": "total5",
		"stats": mage_stats
	},
	"Paladin": {
		"value": "total6",
		"stats": paladin_stats
	}
}


var wave_data = {
	0: [["Test", 1.5], ["Test", 0.1]],
	1: [["Test", 0.1], ["Test", 0.1], ["Test", 0.1], ["Test", 0.1]]
}
