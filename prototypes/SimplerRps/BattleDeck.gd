extends Node2D

const Card = preload("res://Card.tscn")

signal card_selected
export var size = 8

var selected # Card
var tiles = [] # should be called "cards"

func _ready():
	for i in range(size):
		var card_data = Globals.all_cards[randi() % len(Globals.all_cards)]
		card_data = parse_json(to_json(card_data)) # cheap way to copy it
		var card = Card.instance()
		card.set_data(card_data)
		card.position = Vector2(0, i * 64)
		# can send "card" (data) instead
		card.connect("on_click", self, "_set_selected_card", [card])
		add_child(card)
		tiles.append(card)

func own_cards(owned_by):
	for card in tiles:
		card.owned_by = owned_by

func recolour_dark():
	for card in tiles:
		card.recolour_dark()

func remove_card(card):
	# UGH, typecasting: card(Node2D) vs card(script instance)
	
	for i in range(len(tiles)):
		var c = tiles[i]
		if card.strength == c.strength and card.defense == c.defense and card.affinity == c.affinity:
			tiles.remove(i)
			break
			
	self.remove_child(card)
	
func _set_selected_card(card):
	self.selected = card
	self.emit_signal("card_selected", card)