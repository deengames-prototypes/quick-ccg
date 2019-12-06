extends Node2D

const Card = preload("res://Card.tscn")

signal card_selected
export var size = Globals.PLAYER_HAND_SIZE

var selected # Card
var tiles = [] # should be called "cards" - Card.instance()

func set_cards(cards):
	for i in range(len(cards)):
		var card_data = cards[i]
		card_data = parse_json(to_json(card_data)) # cheap way to copy it
		var card = Card.instance()
		card.set_data(card_data)
		card.position = Vector2((i / 9) * Globals.CARD_WIDTH, (i % 9) * Globals.CARD_HEIGHT)
		# can send "card" (data) instead
		card.connect("on_click", self, "_set_selected_card", [card])
		add_child(card)
		tiles.append(card)

func own_cards(owned_by):
	for card in tiles:
		card.owned_by = owned_by

func recolour_to_owner():
	for card in tiles:
		card.recolour_to_owner()

func remove_card(card):

	self.tiles.remove(self.tiles.find(card))
	self.remove_child(card)
	
func _set_selected_card(card):
	self.selected = card
	self.emit_signal("card_selected", card)