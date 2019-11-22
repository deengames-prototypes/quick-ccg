extends Node

const MAX_VALUE = 6
const UNIVERSE_SIZE = 50 # 50 cards in all
var TYPES = ["Triangle", "Circle", "Square"]

var all_cards = []

func _ready():
	for i in range(UNIVERSE_SIZE):
		# Dupes are OK. Don't really care.
		# [1..max]
		var strength = (randi() % MAX_VALUE) + 1
		var defense = (randi() % MAX_VALUE) + 1
		var affinity = TYPES[randi() % len(TYPES)]
		var card = {"strength": strength, "defense": defense, "affinity": affinity}
		all_cards.append(card)