extends Node2D

const Card = preload("res://Card.tscn")

signal card_selected
export var size = 8

var selected # Card

var _cards = []

func _ready():
	for i in range(size):
		var card = Globals.all_cards[randi() % len(Globals.all_cards)]
		_cards.append(card)
		# TODO: replace with card
		var tile = Card.instance()
		tile.set_data(card)
		tile.position = Vector2(0, i * 64)
		# can send "card" (data) instead
		tile.connect("on_click", self, "_set_selected_card", [tile])
		add_child(tile)

func remove_card(card):
	# UGH, typecasting: card(Node2D) vs card(script instance)
	
	for i in range(len(_cards)):
		var c = _cards[i]
		if card.strength == c.strength and card.defense == c.defense and card.affinity == c.affinity:
			_cards.remove(i)
			break
			
	self.remove_child(card)
	
func _set_selected_card(card):
	self.selected = card
	self.emit_signal("card_selected", card)