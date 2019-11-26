extends Node

const MAX_VALUE = 7
const UNIVERSE_SIZE = 50 # 50 cards in all
const PLAYER_DECK_SIZE = 20
const PLAYER_HAND_SIZE = 8
const NUM_NPCS = 5
const BATTLES_TO_LEVEL_UP = 2
const POINTS_PER_LEVEL_UP = 3

var TYPES = ["Triangle", "Circle", "Square"]

var all_cards = []
var player_deck = []
var player_hand = [] # subset of player deck
var npc_decks = [] # array of arrays

# poor excuse for non-string type checking
var player
# shared between NPC and CoreGameScene
var current_npc_deck
var npc_fighting = -1
var battles_until_next_level_up = BATTLES_TO_LEVEL_UP
var stats_points = 0

var map_data = null # array of NPC data, saved/loaded

func _ready():
	randomize()
	
	for i in range(UNIVERSE_SIZE):
		# Dupes are OK. Don't really care.
		# [1..max]
		var defense = (randi() % MAX_VALUE) + 1
		var affinity = TYPES[randi() % len(TYPES)]
		var card = {"defense": defense, "affinity": affinity}
		all_cards.append(card)
		
	for i in range(NUM_NPCS):
		var deck = []
		
		for j in range(8):
		# dupes are fine
			var next = all_cards[randi() % len(all_cards)]
			next = parse_json(to_json(next)) # cheap way to copy it
			deck.append(next)
			
		npc_decks.append(deck)
	
	for i in range(PLAYER_DECK_SIZE):
		var next = all_cards[randi() % len(all_cards)]
		next = parse_json(to_json(next)) # cheap way to copy it
		player_deck.append(next)
	
	for i in range(PLAYER_HAND_SIZE):
		player_hand.append(player_deck[i])
	
func calculate_damage(attacker_card, defender_card):
	var damage_multiplier = affinity_compare(attacker_card.affinity, defender_card.affinity)
	var raw_damage = attacker_card.defense * damage_multiplier
	return max(raw_damage, 0)
	
func affinity_compare(attack_affinity, defend_affinity):
	if attack_affinity == defend_affinity: return 1 # 1x = normal
	
	if (attack_affinity == "Triangle" and defend_affinity == "Circle") or \
	(attack_affinity == "Circle" and defend_affinity == "Square") or \
	(attack_affinity == "Square" and defend_affinity == "Triangle"):
		return 2 # 2x = critical
	
	return 1 # 1x: weak