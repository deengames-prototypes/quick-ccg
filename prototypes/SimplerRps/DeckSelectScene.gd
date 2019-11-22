extends Node2D

const Card = preload("res://Card.tscn")

func _ready():
	for i in range(len(Globals.all_cards)):
		var card = Globals.all_cards[i]
		var c = Card.instance()
		c.set_data(card)
		var x = i % 9
		var y = i / 9
		c.position = Vector2(x * 68, y * 68)
		add_child(c)