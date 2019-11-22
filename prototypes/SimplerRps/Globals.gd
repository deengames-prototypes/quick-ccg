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

func calculate_damage(attacker_card, defender_card):
	var damage_multiplier = affinity_compare(attacker_card.affinity, defender_card.affinity)
	var raw_damage = (attacker_card.strength * damage_multiplier) - defender_card.defense
	return max(raw_damage, 0)
	
func affinity_compare(attack_affinity, defend_affinity):
	if attack_affinity == defend_affinity: return 1 # 1x = normal
	
	if (attack_affinity == "Triangle" and defend_affinity == "Circle") or \
	(attack_affinity == "Circle" and defend_affinity == "Square") or \
	(attack_affinity == "Square" and defend_affinity == "Triangle"):
		return 2 # 2x = critical
	
	return 0.5 # 0.5x: weak