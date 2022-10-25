extends Node

var unit_data = {
	"Soldier": {
		"value": "total1",
		"stats": {
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
	},
	"Archer": {
		"value": "total2",
		"stats": {
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
	}
}


var wave_data = {
	0: [["Test", 1.5], ["Test", 0.1]],
	1: [["Test", 0.1], ["Test", 0.1], ["Test", 0.1], ["Test", 0.1]]
}
