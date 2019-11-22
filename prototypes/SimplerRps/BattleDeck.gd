extends Node2D

const Card = preload("res://Card.tscn")

export var size = 8

func _ready():
	for i in range(size):
		var card = Globals.all_cards[randi() % len(Globals.all_cards)]
		# TODO: replace with card
		var tile = Card.instance()
		tile.set_data(card)
		tile.position = Vector2(0, i * 64)
		add_child(tile)