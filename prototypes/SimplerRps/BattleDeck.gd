extends Node2D

const Card = preload("res://Card.tscn")

export var size = 8
var selected # Card

func _ready():
	for i in range(size):
		var card = Globals.all_cards[randi() % len(Globals.all_cards)]
		# TODO: replace with card
		var tile = Card.instance()
		tile.set_data(card)
		tile.position = Vector2(0, i * 64)
		tile.connect("on_click", self, "_set_selected_card", [tile])
		add_child(tile)

func _set_selected_card(card):
	self.selected = card
	print("clicked on " + str(card))